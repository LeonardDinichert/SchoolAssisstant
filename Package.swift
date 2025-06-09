// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "SchoolAssisstantPackage",
    products: [
        .library(name: "SchoolAssisstantPackage", targets: ["SchoolAssisstantPackage"])
    ],
    targets: [
        .target(name: "SchoolAssisstantPackage", path: "swiftpackage"),
        .testTarget(name: "SchoolAssisstantPackageTests", dependencies: ["SchoolAssisstantPackage"], path: "Tests/SchoolAssisstantPackageTests")
    ]
)
