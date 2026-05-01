{
  koito,
  stdenv,
  fetchYarnDeps,
  yarnConfigHook,
  yarnBuildHook,
  nodejs,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "${koito.pname}-client";
  inherit (koito) version;

  src = "${koito.src}/client";

  yarnOfflineCache = fetchYarnDeps {
    yarnLock = "${finalAttrs.src}/yarn.lock";
    hash = "sha256-9jWyTYrf2ocpzxeX6zDx9vgX+VtqFiX9TapGRZvRico=";
  };

  nativeBuildInputs = [
    yarnConfigHook
    yarnBuildHook
    
    # Needed for executing package.json scripts
    nodejs
  ];

  installPhase = ''
    mkdir $out
    cp -r build/ $out
    cp -r public/ $out
  '';

  meta =
    (removeAttrs koito.meta ["mainProgram"])
    // {
      description = "${koito.meta.description} - Client";
    };
})
