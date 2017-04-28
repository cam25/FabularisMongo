// swift-tools-version:3.1

import PackageDescription

let package = Package(
    name: "FabularisMongo",
    targets: [
        // Framework
//        Target(name: "FabularisMongo", dependencies: [
  //          "MongoModel",
    //        "MongoTurnstile",
      //      ]),
        
        // Misc
        Target(name: "MongoModel"),
        Target(name: "MongoTurnstile", dependencies: ["MongoModel"]),
        Target(name: "MongoSocial", dependencies: ["MongoModel"])
    ],
    dependencies: [
        .Package(url: "https://github.com/OpenKitten/MongoKitten.git", "4.0.0-vaportls"),
        .Package(url: "https://github.com/vapor/vapor.git", majorVersion: 1, minor: 5)
    ]
)
