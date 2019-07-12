"""Load dependencies needed for Stratum."""

load("//bazel:workspace_rule.bzl", "remote_workspace")
load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
load("@bazel_tools//tools/build_defs/repo:git.bzl",
     "git_repository",
     "new_git_repository")

P4RUNTIME_VER = "1.0.0"
P4RUNTIME_SHA = "667464bd369b40b58dc9552be2c84e190a160b6e77137b735bd86e5b81c6adc0"

GNMI_COMMIT = "39cb2fffed5c9a84970bde47b3d39c8c716dc17a";
GNMI_SHA = "3701005f28044065608322c179625c8898beadb80c89096b3d8aae1fbac15108"

def stratum_deps():
# -----------------------------------------------------------------------------
#        Protobuf + gRPC compiler and external models
# -----------------------------------------------------------------------------
    if "com_google_protobuf" not in native.existing_rules():
        remote_workspace(
            name = "com_google_protobuf",
            remote = "https://github.com/google/protobuf",
            tag = "3.7.1",
        )

    if "com_github_grpc_grpc" not in native.existing_rules():
        remote_workspace(
            name = "com_github_grpc_grpc",
            remote = "https://github.com/grpc/grpc",
            tag = "1.21.3",
            patches = ["@//bazel/patches:grpc.patch"],
            patch_args = ["-p1"],
        )

    if "com_google_googleapis" not in native.existing_rules():
        remote_workspace(
            name = "com_google_googleapis",
            remote = "https://github.com/googleapis/googleapis",
            commit = "84c8ad4e52f8eec8f08a60636cfa597b86969b5c",
        )

    if "com_github_p4lang_p4c" not in native.existing_rules():
        # ----- p4c -----
        remote_workspace(
            name = "com_github_p4lang_p4c",
            remote = "https://github.com/p4lang/p4c",
            commit = "43568b75796d68a6424ad22eebeee62f46ccd3fe",
            build_file = "@//bazel:external/p4c.BUILD",
        )

    if "com_github_p4lang_p4runtime" not in native.existing_rules():
        http_archive(
            name = "com_github_p4lang_p4runtime",
            urls = ["https://github.com/p4lang/p4runtime/archive/v%s.zip" % P4RUNTIME_VER],
            sha256 = P4RUNTIME_SHA,
            strip_prefix = "p4runtime-%s/proto" % P4RUNTIME_VER,
            build_file = "@//bazel:external/p4runtime.BUILD",
        )

    if "build_stack_rules_proto" not in native.existing_rules():
        remote_workspace(
            name = "build_stack_rules_proto",
            remote = "https://github.com/stackb/rules_proto",
            commit = "2f4e4f62a3d7a43654d69533faa0652e1c4f5082",
        )

    if "com_github_p4lang_PI" not in native.existing_rules():
        # ----- PI -----
        remote_workspace(
            name = "com_github_p4lang_PI",
            remote = "https://github.com/p4lang/PI.git",
            commit = "0bcaeda2269a4f2f0539cf8eac49868e389a8c18",
        )

    if "judy" not in native.existing_rules():
        http_archive(
            name = "judy",
            build_file = "@com_github_p4lang_PI//bazel/external:judy.BUILD",
            url = "http://archive.ubuntu.com/ubuntu/pool/universe/j/judy/judy_1.0.5.orig.tar.gz",
            strip_prefix = "judy-1.0.5",
        )

    if "com_github_openconfig_gnmi" not in native.existing_rules():
        http_archive(
            name = "com_github_openconfig_gnmi",
            urls = ["https://github.com/bocon13/gnmi/archive/%s.zip" % GNMI_COMMIT],
            sha256 = GNMI_SHA,
            strip_prefix = "gnmi-%s/proto" % GNMI_COMMIT,
            build_file = "@//bazel:external/gnmi.BUILD",
        )

    if "com_github_openconfig_gnoi" not in native.existing_rules():
        remote_workspace(
            name = "com_github_openconfig_gnoi",
            remote = "https://github.com/openconfig/gnoi",
            commit = "437c62e630389aa4547b4f0521d0bca3fb2bf811",
            build_file = "@//bazel:external/gnoi.BUILD",
        )

    if "io_bazel_rules_python" not in native.existing_rules():
        remote_workspace(
            name = "io_bazel_rules_python",
            commit = "8b5d0683a7d878b28fffe464779c8a53659fc645",
            remote = "https://github.com/bazelbuild/rules_python.git",
        )
    if "cython" not in native.existing_rules():
        http_archive(
            name = "cython",
            build_file = "@com_github_grpc_grpc//third_party:cython.BUILD",
            sha256 = "d68138a2381afbdd0876c3cb2a22389043fa01c4badede1228ee073032b07a27",
            strip_prefix = "cython-c2b80d87658a8525ce091cbe146cb7eaa29fed5c",
            urls = [
                "https://github.com/cython/cython/archive/c2b80d87658a8525ce091cbe146cb7eaa29fed5c.tar.gz",
            ],
        )

# -----------------------------------------------------------------------------
#        Third party C++ libraries for common
# -----------------------------------------------------------------------------
    if "com_google_absl" not in native.existing_rules():
        remote_workspace(
            name = "com_google_absl",
            remote = "https://github.com/abseil/abseil-cpp",
            branch = "master",
        )

    if "com_googlesource_code_cctz" not in native.existing_rules():
        # CCTZ (Time-zone framework); required for Abseil time
        remote_workspace(
            name = "com_googlesource_code_cctz",
            remote = "https://github.com/google/cctz",
            branch = "master",
        )

    if "com_github_google_glog" not in native.existing_rules():
        remote_workspace(
            name = "com_github_google_glog",
            remote = "https://github.com/google/glog",
            branch = "master",
        )

    if "com_github_gflags_gflags" not in native.existing_rules():
        remote_workspace(
            name = "com_github_gflags_gflags",
            remote = "https://github.com/gflags/gflags",
            branch = "master",
        )

    if "com_google_googletest" not in native.existing_rules():
        remote_workspace(
            name = "com_google_googletest",
            remote = "https://github.com/google/googletest",
            branch = "master",
        )

    if "com_googlesource_code_re2" not in native.existing_rules():
        remote_workspace(
            name = "com_googlesource_code_re2",
            remote = "https://github.com/google/re2",
            branch = "master",
        )

    if "com_github_systemd_systemd" not in native.existing_rules():
        remote_workspace(
            name = "com_github_systemd_systemd",
            remote = "https://github.com/systemd/systemd",
            branch = "master",
            build_file = "@//bazel:external/systemd.BUILD",
        )

    if "boringssl" not in native.existing_rules():
        remote_workspace(
            name = "boringssl",
            remote = "https://github.com/google/boringssl",
            branch = "chromium-stable-with-bazel",
            #commit = "90bd81032325ba659e538556e64977c29df32a3c", or afc30d43eef92979b05776ec0963c9cede5fb80f
        )

    if "com_github_nelhage_rules_boost" not in native.existing_rules():
        remote_workspace(
            name = "com_github_nelhage_rules_boost",
            remote = "https://github.com/nelhage/rules_boost",
            commit = "a3b25bf1a854ca7245d5786fda4821df77c57827",
        )

# -----------------------------------------------------------------------------
#      Golang specific libraries.
# -----------------------------------------------------------------------------
    if "bazel_latex" not in native.existing_rules():
        http_archive(
            name = "bazel_latex",
            sha256 = "66ca4240628a4e40cc02d7f77f06b93269dad0068e7a844009fd439e5c55f5a9",
            strip_prefix = "bazel-latex-0.17",
            url = "https://github.com/ProdriveTechnologies/bazel-latex/archive/v0.17.tar.gz",
        )

# -----------------------------------------------------------------------------
#      Golang specific libraries.
# -----------------------------------------------------------------------------
    if "net_zlib" not in native.existing_rules():
        native.bind(
            name = "zlib",
            actual = "@net_zlib//:zlib",
        )
        http_archive(
            name = "net_zlib",
            build_file = "@com_google_protobuf//:third_party/zlib.BUILD",
            sha256 = "c3e5e9fdd5004dcb542feda5ee4f0ff0744628baf8ed2dd5d66f8ca1197cb1a1",
            strip_prefix = "zlib-1.2.11",
            urls = ["https://zlib.net/zlib-1.2.11.tar.gz"],
        )
    if "io_bazel_rules_go" not in native.existing_rules():
        remote_workspace(
            name = "io_bazel_rules_go",
            remote = "https://github.com/bazelbuild/rules_go",
            commit = "2eb16d80ca4b302f2600ffa4f9fc518a64df2908",
        )

    if "bazel_gazelle" not in native.existing_rules():
        remote_workspace(
            name = "bazel_gazelle",
            remote = "https://github.com/bazelbuild/bazel-gazelle",
            commit = "e443c54b396a236e0d3823f46c6a931e1c9939f2",
        )
# -----------------------------------------------------------------------------
#        Chipset and Platform specific C++ libraries
# -----------------------------------------------------------------------------
    if "com_github_bcm_sdklt" not in native.existing_rules():
        remote_workspace(
            name = "com_github_bcm_sdklt",
            remote = "https://github.com/Broadcom-Network-Switching-Software/SDKLT",
            branch = "master",
            build_file = "@//bazel:external/sdklt.BUILD",
        )
