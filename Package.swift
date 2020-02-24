// swift-tools-version:5.0
import PackageDescription

let package = Package(
    name: "DropDown",
    platforms: [
        .iOS(.v8)
    ],
    products: [
        .library(
            name: "DropDown",
            targets: ["DropDown"])
    ],
    targets: [
        .target(
            name: "DropDown",
            path: "DropDown"
        )
    ]
)
