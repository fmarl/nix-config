{ config, pkgs, lib, ... }:

{
  services = {
    zfs = {
      autoScrub.enable = true;
      autoSnapshot.enable = true;
      # TODO: autoReplication
    };

    jupyter = {
      enable = true;
      group = "jupyter";
      password = "'argon2:$argon2id$v=19$m=10240,t=10,p=8$Dk8rc8D44yJbNMq9+0AWlA$OWl7vJnNAoQRbekP6cxvIMdpUWtpOYmxcazhdWxJT6Y'";
      kernels =
        {
          python3 =
            let
              env = (pkgs.python3.withPackages (pythonPackages: with pythonPackages; [
                ipykernel
                pandas
                scikit-learn
                jupyter
                numpy
                tensorflow
                matplotlib
                seaborn
              ]));
            in
            {
              displayName = "Python 3 for machine learning";
              argv = [
                "''${env.interpreter}"
                "-m"
                "ipykernel_launcher"
                "-f"
                "{connection_file}"
              ];
              language = "python";
            };

          scala =
            let
              env = (pkgs.python3.withPackages (pythonPackages: with pythonPackages; [
                ipykernel
                jupyter
                (
                  (
                    buildPythonPackage rec {
                      pname = "spylon-kernel";
                      version = "0.4.1";
                      src = fetchPypi {
                        inherit pname version;
                        sha256 = "sha256-N4pvxlL2r42/vUhmi8GgvGi8ofKOiTKYXYio9tpLKas=";
                      };

                      buildInputs = [
                        metakernel
                        ipykernel
                        pyyaml
                        (
                          buildPythonPackage rec {
                            pname = "findspark";
                            version = "2.0.1";
                            src = fetchPypi {
                              inherit pname version;
                              sha256 = "sha256-qhCpbLYWyrMpGB1y6O8T0txFO0ur0CtUgkcaCILBGV4=";
                            };
                            doCheck = false;
                          }
                        )
                        (
                          buildPythonPackage rec {
                            pname = "spylon";
                            version = "0.3.0";
                            src = fetchPypi {
                              inherit pname version;
                              sha256 = "sha256-EEub96KMFcJ7PD3LoZn4R7k/CbeOl/FeCgvKw8uwu+Q=";
                            };
                            doCheck = false;
                          }
                        )
                      ];
                      doCheck = false;
                    }
                  )
                )
              ]));
            in
            {
              displayName = "Scala with Spark";
              argv = [
                "''${env.interpreter}"
                "-m"
                "ipykernel_launcher"
                "-f"
                "{connection_file}"
              ];
              language = "scala";
            };
        };
    };

    openssh = {
      enable = true;
      permitRootLogin = "no";
      passwordAuthentication = false;
      hostKeys =
        [
          {
            path = "/persist/etc/ssh/ssh_host_ed25519_key";
            type = "ed25519";
          }
          {
            path = "/persist/etc/ssh/ssh_host_rsa_key";
            type = "rsa";
            bits = 4096;
          }
        ];
    };
  };
}
