genrule(
    name = "terraform",
    srcs = [
        "@third_party/repo/infrastructure//build/defs:terraform",
    ],
    outs = ["terraform.build_defs"],
    cmd = """
cp $SRCS $OUTS
sed -i 's#//#@third_party/repo/infrastructure//#g' $OUTS
    """,
    visibility = ["PUBLIC"],
)
