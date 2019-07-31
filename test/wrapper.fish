# Test that a couple of commands have the same effect when run through
# the fish wrapper and directly.
# Verifies equality of (standard) output, exit code, and PATH.

set test_commands \
    "sdk" \
    "sdk version" \
    "sdk list java" \
    "sdk update" \
    "sdk use ant 1.9.9" \
    "sdk offline enable > /dev/null; sdk install ant foo" \
    "sdk use ant 1.9.9 > /dev/null; sdk broadcast"
set test_count (count $test_commands)
set check_count (math "3 * $test_count")

set sdk_init "$HOME/.sdkman/bin/sdkman-init.sh"

function checksum -a file
    sha256sum $file | cut -d " " -f 1
end

echo "Testing the sdk wrapper"
set failures 0
for sdk_cmd in $test_commands
    echo "  Testing '$sdk_cmd'"
    bash -c "source \"$sdk_init\" && $sdk_cmd > sout_bash;
             echo \"\$?\" > status_bash;
             echo \"\$PATH\" > path_bash;
             echo \"\$ANT_HOME\" > anthome_bash"
    fish -c "$sdk_cmd > sout_fish;
             echo \"\$status\" > status_fish;
             echo \"\$PATH\" > path_fish;
             echo \"\$ANT_HOME\" > anthome_fish"

    # For nicer diffs: one entry per line, sorted
    string split ":" (cat path_bash) | sort > path_bash
    string split ":" (cat path_fish) \
      | string split " " \
      | sort > path_fish
      # split by spaces for fish 2.*

    for out in sout status path anthome
        if [ (checksum "$out"_bash) != (checksum "$out"_fish) ]
            echo "  - $out bad:"
            diff "$out"_bash "$out"_fish | sed -e 's/^/    /'
            set failures (math $failures + 1)
        else
            echo "  - $out ok!"
        end
    end
    echo ""
end

rm {sout,status,path}_{bash,fish}

echo "Ran $test_count commands with 3 checks each."
echo "$failures/$check_count checks failed."
exit $failures
