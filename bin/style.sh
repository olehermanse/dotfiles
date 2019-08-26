find -E . -regex '.*\.(md|h|c|am|sh)' -type f -exec replacer.py --loop ' \n'      '\n'     '{}' \;
find -E . -regex '.*\.am'             -type f -exec replacer.py --loop '\n        '   '\n\t'   '{}' \;
find -E . -regex '.*\.am'             -type f -exec replacer.py --loop '\n    '   '\n\t'   '{}' \;
find -E . -regex '.*\.am'             -type f -exec replacer.py --loop '\n  '     '\n\t'   '{}' \;
find -E . -regex '.*\.md'             -type f -exec replacer.py --loop '\n\n\n\n' '\n\n\n' '{}' \;
