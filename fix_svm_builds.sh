#!/bin/bash
# Fix duplicate SOLC_VERSION entries in svm-rs-builds generated file
BUILDS_RS=$(find target -name "builds.rs" -path "*/svm-rs-builds*" 2>/dev/null | head -1)
if [ -n "$BUILDS_RS" ]; then
    # Remove duplicate SOLC_VERSION_0_8_31 entries (keep first, remove second)
    sed -i '' '/^pub const SOLC_VERSION_0_8_31: semver::Version = semver::Version::new(0,8,31);$/{ N; /^pub const SOLC_VERSION_0_8_31: semver::Version = semver::Version::new(0,8,31);\npub const SOLC_VERSION_0_8_31_CHECKSUM: &str = "f5a243d6b2dd8fba307e36c5fefa2d8eb3ae74ba81036d1c17c971b5d346ade9";$/d; }' "$BUILDS_RS"
    # Also fix the array/list that references it twice
    sed -i '' 's/SOLC_VERSION_0_8_31,\nSOLC_VERSION_0_8_31,/SOLC_VERSION_0_8_31,/' "$BUILDS_RS"
    # Fix the checksum map
    sed -i '' 's/(0,8,31)  => SOLC_VERSION_0_8_31_CHECKSUM,\n(0,8,31)  => SOLC_VERSION_0_8_31_CHECKSUM,/(0,8,31)  => SOLC_VERSION_0_8_31_CHECKSUM,/' "$BUILDS_RS"
    echo "Fixed duplicate entries in $BUILDS_RS"
fi
