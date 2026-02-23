# This file is maintained automatically by "terraform init".
# Manual edits may be lost in future updates.

provider "registry.terraform.io/gavinbunney/kubectl" {
  version     = "1.19.0"
  constraints = ">= 1.14.0"
  hashes = [
    "h1:9QkxPjp0x5FZFfJbE+B7hBOoads9gmdfj9aYu5N4Sfc=",
    "zh:1dec8766336ac5b00b3d8f62e3fff6390f5f60699c9299920fc9861a76f00c71",
    "zh:43f101b56b58d7fead6a511728b4e09f7c41dc2e3963f59cf1c146c4767c6cb7",
    "zh:4c4fbaa44f60e722f25cc05ee11dfaec282893c5c0ffa27bc88c382dbfbaa35c",
    "zh:51dd23238b7b677b8a1abbfcc7deec53ffa5ec79e58e3b54d6be334d3d01bc0e",
    "zh:5afc2ebc75b9d708730dbabdc8f94dd559d7f2fc5a31c5101358bd8d016916ba",
    "zh:6be6e72d4663776390a82a37e34f7359f726d0120df622f4a2b46619338a168e",
    "zh:72642d5fcf1e3febb6e5d4ae7b592bb9ff3cb220af041dbda893588e4bf30c0c",
    "zh:9b12af85486a96aedd8d7984b0ff811a4b42e3d88dad1a3fb4c0b580d04fa425",
    "zh:a1da03e3239867b35812ee031a1060fed6e8d8e458e2eaca48b5dd51b35f56f7",
    "zh:b98b6a6728fe277fcd133bdfa7237bd733eae233f09653523f14460f608f8ba2",
    "zh:bb8b071d0437f4767695c6158a3cb70df9f52e377c67019971d888b99147511f",
    "zh:dc89ce4b63bfef708ec29c17e85ad0232a1794336dc54dd88c3ba0b77e764f71",
    "zh:dd7dd18f1f8218c6cd19592288fde32dccc743cde05b9feeb2883f37c2ff4b4e",
    "zh:ec4bd5ab3872dedb39fe528319b4bba609306e12ee90971495f109e142d66310",
    "zh:f610ead42f724c82f5463e0e71fa735a11ffb6101880665d93f48b4a67b9ad82",
  ]
}

provider "registry.terraform.io/hashicorp/helm" {
  version     = "3.1.1"
  constraints = "3.1.1"
  hashes = [
    "h1:5b2ojWKT0noujHiweCds37ZreRFRQLNaErdJLusJN88=",
    "zh:1a6d5ce931708aec29d1f3d9e360c2a0c35ba5a54d03eeaff0ce3ca597cd0275",
    "zh:3411919ba2a5941801e677f0fea08bdd0ae22ba3c9ce3309f55554699e06524a",
    "zh:81b36138b8f2320dc7f877b50f9e38f4bc614affe68de885d322629dd0d16a29",
    "zh:95a2a0a497a6082ee06f95b38bd0f0d6924a65722892a856cfd914c0d117f104",
    "zh:9d3e78c2d1bb46508b972210ad706dd8c8b106f8b206ecf096cd211c54f46990",
    "zh:a79139abf687387a6efdbbb04289a0a8e7eaca2bd91cdc0ce68ea4f3286c2c34",
    "zh:aaa8784be125fbd50c48d84d6e171d3fb6ef84a221dbc5165c067ce05faab4c8",
    "zh:afecd301f469975c9d8f350cc482fe656e082b6ab0f677d1a816c3c615837cc1",
    "zh:c54c22b18d48ff9053d899d178d9ffef7d9d19785d9bf310a07d648b7aac075b",
    "zh:db2eefd55aea48e73384a555c72bac3f7d428e24147bedb64e1a039398e5b903",
    "zh:ee61666a233533fd2be971091cecc01650561f1585783c381b6f6e8a390198a4",
    "zh:f569b65999264a9416862bca5cd2a6177d94ccb0424f3a4ef424428912b9cb3c",
  ]
}

provider "registry.terraform.io/hashicorp/kubernetes" {
  version     = "3.0.1"
  constraints = "3.0.1"
  hashes = [
    "h1:vyHdH0p6bf9xp1NPePObAJkXTJb/I09FQQmmevTzZe0=",
    "zh:02d55b0b2238fd17ffa12d5464593864e80f402b90b31f6e1bd02249b9727281",
    "zh:20b93a51bfeed82682b3c12f09bac3031f5bdb4977c47c97a042e4df4fb2f9ba",
    "zh:6e14486ecfaee38c09ccf33d4fdaf791409f90795c1b66e026c226fad8bc03c7",
    "zh:8d0656ff422df94575668e32c310980193fccb1c28117e5c78dd2d4050a760a6",
    "zh:9795119b30ec0c1baa99a79abace56ac850b6e6fbce60e7f6067792f6eb4b5f4",
    "zh:b388c87acc40f6bd9620f4e23f01f3c7b41d9b88a68d5255dec0a72f0bdec249",
    "zh:b59abd0a980649c2f97f172392f080eaeb18e486b603f83bf95f5d93aeccc090",
    "zh:ba6e3060fddf4a022087d8f09e38aa0001c705f21170c2ded3d1c26c12f70d97",
    "zh:c12626d044b1d5501cf95ca78cbe507c13ad1dd9f12d4736df66eb8e5f336eb8",
    "zh:c55203240d50f4cdeb3df1e1760630d677679f5b1a6ffd9eba23662a4ad05119",
    "zh:ea206a5a32d6e0d6e32f1849ad703da9a28355d9c516282a8458b5cf1502b2a1",
    "zh:f569b65999264a9416862bca5cd2a6177d94ccb0424f3a4ef424428912b9cb3c",
  ]
}

provider "registry.terraform.io/hashicorp/vault" {
  version     = "5.6.0"
  constraints = "5.6.0"
  hashes = [
    "h1:qRzvy+n5SM0Dz1TSW/DGSK8jfG3Lwj+dv0xM7in2AhM=",
    "zh:062bfab310e25164ea1bd9a2b86eb0e07ebf67d66f1cea32af84432a8a0a3f15",
    "zh:0fbff85de06502af491dc1992a1a9de5b7066d9dd12095350c73cd9e2a80d11e",
    "zh:255dd6c50d9f069486b36ed13612a1fb7fcaed1949861fb6bc1681bd668ab223",
    "zh:2e99f2dbff55363e1b97370858735a1a8f680d4f4ff28e4665727bafd504d253",
    "zh:3deba8d0c6987cf4613664ec46be0caa071621295a51135a6142742bd73e9c9c",
    "zh:50b6660462cc9fb20b8343c5e11fa7d026e5f805c96223b032eb10de76583349",
    "zh:6338f19114edc8b754bfc8c144d37c71dd6b1a511d388e0118f5eac446a8c5eb",
    "zh:6671aeecd9f056509612b22c20cf5c52392bd7ca52ee5db9988e68d34cde2c8d",
    "zh:78d5eefdd9e494defcb3c68d282b8f96630502cac21d1ea161f53cfe9bb483b3",
    "zh:944692c575f710ff6412efecee401b56981df7cfe2ae6a0c0e54b7c38a92934e",
    "zh:d5a73da30ac8db0ecc4bf4bab733ddcad009ae768d30dc6ae212db2e1d1ad34f",
    "zh:fbd46583f3037a85cbc5995e15bb72a08903e9afc5a06dd9b23de251efc58225",
  ]
}
