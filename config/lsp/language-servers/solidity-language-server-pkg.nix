{
  lib,
  mkYarnPackage,
  fetchFromGitHub,
  fetchYarnDeps,
  makeWrapper,
  nodejs,
}:
mkYarnPackage rec {
  pname = "solidity-language-server";
  version = "0.7.3"; # Replace with the current version

  src = fetchFromGitHub {
    owner = "NomicFoundation";
    repo = "hardhat-vscode";
    rev = "v${version}";
    hash = "sha256-XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"; # Replace with the actual hash
  };

  packageJSON = ./server/package.json; # You'll need to provide this file
  yarnLock = ./server/yarn.lock; # You'll need to provide this file

  offlineCache = fetchYarnDeps {
    yarnLock = "${src}/server/yarn.lock";
    hash = "sha256-YYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYY"; # Replace with the actual hash
  };

  nativeBuildInputs = [
    nodejs
    makeWrapper
  ];

  buildPhase = ''
    runHook preBuild
    cd deps/${pname}
    yarn build
    runHook postBuild
  '';

  postInstall = ''
    makeWrapper '${nodejs}/bin/node' "$out/bin/nomicfoundation-solidity-language-server" \
      --add-flags "$out/libexec/${pname}/deps/${pname}/dist/src/server.js" \
      --set NODE_ENV production
  '';

  meta = with lib; {
    description = "Solidity Language Server";
    homepage = "https://github.com/NomicFoundation/hardhat-vscode/tree/main/server";
    license = licenses.mit;
    maintainers = with maintainers; []; # Add yourself or other maintainers here
    platforms = platforms.all;
  };
}
