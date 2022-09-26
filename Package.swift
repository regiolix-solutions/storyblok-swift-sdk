// swift-tools-version: 5.6

import PackageDescription

 let package = Package(
     name: "RXSStoryblokClient",
     platforms: [.macOS(.v10_10), .iOS(.v13)],
     products: [
         .library(name: "RXSStoryblokClient", targets: ["RXSStoryblokClient"]),
     ],
     targets: [
         .target(name: "RXSStoryblokClient")
     ]
 )
