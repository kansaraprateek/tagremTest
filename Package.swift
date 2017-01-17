import PackageDescription

let package = Package(
    name: "Users",
    dependencies: [
        .Package(url: "https://github.com/vapor/vapor.git", majorVersion: 1, minor: 3),
        .Package(url: "https://github.com/vapor/mysql-provider.git", majorVersion: 1, minor:1),
        .Package(url: "https://github.com/sfaxon/vapor-memory-provider.git", Version(1,0,0))
    ],
    exclude: [
        "Config",
        "Deploy",
        "Public",
        "Resources",
        "Tests",
        "Database"
    ]
)

