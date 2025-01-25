{ ... }@_haumeaArgs:
{ pkgs, ... }@_nixosModuleArgs:
let
  wazuhUser = "wazuh";
  wazuhGroup = wazuhUser;
  stateDir = "/var/ossec";
  agentConfig = pkgs.writeText "ossec.conf" ''
    <!--
      Wazuh - Agent - Default configuration.
      More info at: https://documentation.wazuh.com
      Mailing list: https://groups.google.com/forum/#!forum/wazuh
    -->

    <ossec_config>
      <client>
        <server>
          <address>api.wazuh.formelio.nl</address>
          <port>1514</port>
        </server>
        <config-profile>debian, debian8</config-profile>
        <crypto_method>aes</crypto_method>
        <enrollment>
          <groups>engineers,default</groups>
        </enrollment>
      </client>

      <client_buffer>
        <!-- Agent buffer options -->
        <disabled>no</disabled>
        <queue_size>5000</queue_size>
        <events_per_second>500</events_per_second>
      </client_buffer>

      <!-- Policy monitoring -->
      <rootcheck>
        <disabled>no</disabled>

        <!-- Frequency that rootcheck is executed - every 12 hours -->
        <frequency>43200</frequency>

        <rootkit_files>/var/ossec/etc/shared/rootkit_files.txt</rootkit_files>
        <rootkit_trojans>/var/ossec/etc/shared/rootkit_trojans.txt</rootkit_trojans>

        <system_audit>/var/ossec/etc/shared/system_audit_rcl.txt</system_audit>
        <system_audit>/var/ossec/etc/shared/system_audit_ssh.txt</system_audit>
        <system_audit>/var/ossec/etc/shared/cis_debian_linux_rcl.txt</system_audit>

        <skip_nfs>yes</skip_nfs>
      </rootcheck>

      <wodle name="open-scap">
        <disabled>yes</disabled>
        <timeout>1800</timeout>
        <interval>1d</interval>
        <scan-on-start>yes</scan-on-start>

        <content type="xccdf" path="ssg-debian-8-ds.xml">
          <profile>xccdf_org.ssgproject.content_profile_common</profile>
        </content>
        <content type="oval" path="cve-debian-oval.xml"/>
      </wodle>

      <wodle name="syscollector">
        <disabled>no</disabled>
        <interval>1h</interval>
        <scan_on_start>yes</scan_on_start>
        <hardware>yes</hardware>
        <os>yes</os>
        <network>yes</network>

        <!-- Database synchronization settings -->
        <synchronization>
          <max_eps>10</max_eps>
        </synchronization>
      </wodle>

      <!-- File integrity monitoring -->
      <syscheck>
        <disabled>no</disabled>

        <!-- Frequency that syscheck is executed default every 12 hours -->
        <frequency>43200</frequency>

        <scan_on_start>yes</scan_on_start>

        <!-- Directories to check  (perform all possible verifications) -->
        <directories>/etc,/usr/bin,/usr/sbin</directories>
        <directories>/bin,/sbin,/boot</directories>

        <!-- Files/directories to ignore -->
        <ignore>/etc/mtab</ignore>
        <ignore>/etc/hosts.deny</ignore>
        <ignore>/etc/mail/statistics</ignore>
        <ignore>/etc/random-seed</ignore>
        <ignore>/etc/random.seed</ignore>
        <ignore>/etc/adjtime</ignore>
        <ignore>/etc/httpd/logs</ignore>
        <ignore>/etc/utmpx</ignore>
        <ignore>/etc/wtmpx</ignore>
        <ignore>/etc/cups/certs</ignore>
        <ignore>/etc/dumpdates</ignore>
        <ignore>/etc/svc/volatile</ignore>
        <ignore>/sys/kernel/security</ignore>
        <ignore>/sys/kernel/debug</ignore>

        <!-- File types to ignore -->
        <ignore type="sregex">.log$|.swp$</ignore>

        <!-- Check the file, but never compute the diff -->
        <nodiff>/etc/ssl/private.key</nodiff>

        <skip_nfs>yes</skip_nfs>
        <skip_dev>yes</skip_dev>
        <skip_proc>yes</skip_proc>
        <skip_sys>yes</skip_sys>

        <!-- Nice value for Syscheck process -->
        <process_priority>10</process_priority>

        <!-- Maximum output throughput -->
        <max_eps>50</max_eps>

        <!-- Database synchronization settings -->
        <synchronization>
          <enabled>yes</enabled>
          <interval>5m</interval>
          <max_eps>10</max_eps>
        </synchronization>
      </syscheck>

      <!-- Log analysis -->
      <localfile>
        <log_format>syslog</log_format>
        <location>/var/ossec/logs/active-responses.log</location>
      </localfile>

      <localfile>
        <log_format>syslog</log_format>
        <location>/var/log/messages</location>
      </localfile>

      <localfile>
        <log_format>syslog</log_format>
        <location>/var/log/auth.log</location>
      </localfile>

      <localfile>
        <log_format>syslog</log_format>
        <location>/var/log/syslog</location>
      </localfile>

      <localfile>
        <log_format>command</log_format>
        <command>df -P</command>
        <frequency>360</frequency>
      </localfile>

      <localfile>
        <log_format>full_command</log_format>
        <command>netstat -tan |grep LISTEN |grep -v 127.0.0.1 | sort</command>
        <frequency>360</frequency>
      </localfile>

      <localfile>
        <log_format>full_command</log_format>
        <command>last -n 5</command>
        <frequency>360</frequency>
      </localfile>

      <!-- Active response -->
      <active-response>
        <disabled>no</disabled>
      </active-response>

    </ossec_config>
  '';
  pkg =
    let
      inherit (pkgs)
        lib
        stdenv
        fetchgit
        fetchurl
        autoconf
        automake
        cmake
        curl
        libgcc
        libtool
        openssl
        perl
        policycoreutils
        python312
        zstd
        ;
      dependencyVersion = "26";
      fetcher =
        ({ name, sha256 }:
          fetchurl {
            inherit sha256;
            url = "https://packages.wazuh.com/deps/${dependencyVersion}/libraries/sources/${name}.tar.gz";
          });
      dependencies = [
        (fetcher
          {
            name = "cJSON";
            sha256 = "sha256-Z415YxjaV9XzgHXnS7s7dzddw/i7Sdo0GtG0PEF+jME=";
          })
        (fetcher
          {
            name = "curl";
            sha256 = "sha256-QBUdS8paLByEDtIkNx/g2VFSMXalvDxNA2Lz2m+WZUA=";
          })
        (fetcher
          {
            name = "libdb";
            sha256 = "sha256-fpxE6Mf9sYb/UhqNCFsb+mNNNC3Md37Oofv5qYq13F4=";
          })
        (fetcher
          {
            name = "libffi";
            sha256 = "sha256-DpcfZLrMIglOifA0u6B1tA7MLCwpAO7NeuhYFf1sn2k=";
          })
        (fetcher
          {
            name = "libyaml";
            sha256 = "sha256-NdqtYIs3LVzgmfc4wPIb/MA9aSDZL0SDhsWE5mTxN2o=";
          })
        (fetcher
          {
            name = "openssl";
            sha256 = "sha256-I4QVZBEgyPednBwsr5e4jT1tvtVihZ3QZjvUto3CF54=";
          })
        (fetcher
          {
            name = "procps";
            sha256 = "sha256-Ih85XinRvb5LrMnbOWAu7guuaFqTVDe+DX/rQuMZLQc=";
          })
        (fetcher
          {
            name = "sqlite";
            sha256 = "sha256-mo+mqRb4whB+1l2rjc7TkmBOF1EE1qjDycE4NHmGnwc=";
          })
        (fetcher
          {
            name = "zlib";
            sha256 = "sha256-tZ04FJ8MKexU0nZmEevFpRoDK/lxfjmprwD7bLhTK4s=";
          })
        (fetcher
          {
            name = "audit-userspace";
            sha256 = "sha256-6Coy5e35OwVRYOFLyX9B3q05KHklhR3ICnY44tTTBDQ=";
          })
        (fetcher
          {
            name = "msgpack";
            sha256 = "sha256-BtY7zzKJbNCvVIDEARNLGtHBZv2E6+W0hueSEB7oVOI=";
          })
        (fetcher
          {
            name = "bzip2";
            sha256 = "sha256-J2iO4DFqZLOeURssIkBwytl8OUpfcR+dBV/BgJ2JW80=";
          })
        (fetcher
          {
            name = "nlohmann";
            sha256 = "sha256-zvsHk209W/3T78Xpu408gH1oEnO9rC6Ds9Z67y0RWMQ=";
          })
        (fetcher
          {
            name = "googletest";
            sha256 = "sha256-jB6KCn8iHCEl6Z5qy3CdorpHJHa00FfFjeUEvr841Bc=";
          })
        (fetcher
          {
            name = "libpcre2";
            sha256 = "sha256-WoDWVNfRSz25+jpJ179EpJhoO0Z4SojOxRSosZR2e5I=";
          })
        (fetcher
          {
            name = "libplist";
            sha256 = "sha256-iCeNS9/BvWo6GlWk89kzaD0nMroJz3p0n+jsjuxAbjw=";
          })
        (fetcher
          {
            name = "pacman";
            sha256 = "sha256-9n3Tiir7NA19YDUNSbdamDp8TgGtdgIFaSDv6EnVsUM=";
          })
        (fetcher
          {
            name = "libarchive";
            sha256 = "sha256-yVgEgXXa1aE9CFHQPHwaNjYeEujpPnQywYROlUnd9Yo=";
          })
        (fetcher
          {
            name = "popt";
            sha256 = "sha256-1ogKBmIsoy3EqjmtXc977y+qgb2TGvvmS6Q0rY/uHao=";
          })
        (fetcher
          {
            name = "rpm";
            sha256 = "sha256-rvwlMB7M8irFHL2BOn89RHHxxCYYFy7lSKKbGVmsW68=";
          })
        (fetcher
          {
            name = "cpython";
            sha256 = "sha256-nmWwlXdfkrLxHT6zW6L55syAeL3Je6oY7470IN/CfUA=";
          })
        (fetcher
          {
            name = "jemalloc";
            sha256 = "sha256-KyLoWzUsffVQukCKQiUeUejf+myRqi4ftIBKsxf/vKA=";
          })
        (fetcher
          {
            name = "lua";
            sha256 = "sha256-Yu634kskbFBwi81Nkts8nejRltlMnDO4v/QA8l8QWh8=";
          })
        (fetcher
          {
            name = "rocksdb";
            sha256 = "sha256-7u1go9Tin3MF55+fXOvUJhF0JhIn8bWn0F2lVWVnVDY=";
          })
        (fetcher
          {
            name = "lzma";
            sha256 = "sha256-TODBktQQcrVnmvibtTHvtoXIJnpLfiAFmZFJrBcCgTQ=";
          })
        (fetcher
          {
            name = "cpp-httplib";
            sha256 = "sha256-ZRdXMmNhFoa5IZunlsNfVKMG6yfcPHLhgH8qCjTKweg=";
          })
        (fetcher
          {
            name = "benchmark";
            sha256 = "sha256-lMV6oMsr142+nnfTMsvGRNrw/s3JoJYyBIvm4J+c7Ws=";
          })
        (fetcher
          {
            name = "flatbuffers";
            sha256 = "sha256-lDaZof6GwZc3HNIUxMNV2g8lOjCT8Mc/t0y0xIuJeKk=";
          })
      ];
    in
    stdenv.mkDerivation rec {
      pname = "wazuh-agent";
      version = "4.8.1";

      meta = {
        description = "Wazuh agent for NixOS";
        homepage = "https://wazuh.com";
      };

      src = fetchgit {
        url = "https://github.com/wazuh/wazuh";
        rev = "refs/tags/v${version}";
        sha256 = "sha256-dZw0biY5fBDDcnQYsMUTCVyw7sROH5X3OX8NYgwnu6M=";
        fetchSubmodules = true;
      };

      workingDirectory = "x84_64-linux-src";

      env = {
        OSSEC_LIBS = "-lzstd";
      };

      buildInputs = [
        autoconf
        automake
        cmake
        curl
        stdenv.cc.libcxx
        stdenv.cc.coreutils_bin
        libtool
        openssl
        perl
        policycoreutils
        python312
        zstd
      ];

      unpackPhase = ''
        mkdir -p $workingDirectory/src/external
        cp --no-preserve=all -rf $src/* $workingDirectory
        ${lib.strings.concatMapStringsSep "\n" (dep: "tar -xzf ${dep} -C $workingDirectory/src/external") dependencies}
      '';

      patchPhase = ''
        # Patch audit_userspace autogen.sh script
        substituteInPlace $workingDirectory/src/external/audit-userspace/autogen.sh \
          --replace-warn "cp INSTALL.tmp INSTALL" ""

        # Required for OpenSSL to compile
        chmod +x $workingDirectory/src/external/openssl/Configure
        substituteInPlace $workingDirectory/src/Makefile \
          --replace-warn "./config \$(OPENSSL_FLAGS)" "${perl}/bin/perl ./Configure \$(OPENSSL_FLAGS)"

        # Bypass check for tar file
        touch $workingDirectory/src/external/cpython.tar

        cat << EOF > "$workingDirectory/etc/preloaded-vars.conf"
        USER_LANGUAGE="en"
        USER_NO_STOP="y"
        USER_INSTALL_TYPE="agent"
        USER_DIR="$out"
        USER_DELETE_DIR="n"
        USER_ENABLE_ACTIVE_RESPONSE="y"
        USER_ENABLE_SYSCHECK="y"
        USER_ENABLE_ROOTCHECK="y"
        USER_ENABLE_OPENSCAP="y"
        USER_ENABLE_SYSCOLLECTOR="y"
        USER_ENABLE_SECURITY_CONFIGURATION_ASSESSMENT="y"
        USER_AGENT_SERVER_IP=127.0.0.1
        USER_CA_STORE="no"
        EOF

        ln -sf ${libgcc.lib}/lib/libgcc_s.so.1 $workingDirectory/src/libgcc_s.so.1
        ln -sf ${libgcc.lib}/lib/libstdc++.so.6 $workingDirectory/src/libstdc++.so.6
      '';

      dontConfigure = true;

      makeFlags = [ "-C ${workingDirectory}/src" "TARGET=agent" "INSTALLDIR=$out" ];

      preBuild = ''
        make -C $workingDirectory/src deps
      '';

      enableParallelBuilding = true;

      dontFixup = true;

      installPhase = ''
        mkdir -p $out/{bin,etc/shared,queue,var,wodles,logs,lib,tmp,agentless,active-response}

        # Bypass root check
        substituteInPlace $workingDirectory/install.sh \
          --replace-warn "Xroot" "Xnixbld"
        chmod u+x $workingDirectory/install.sh

        # Allow files to copy over even if permissions are not changed
        substituteInPlace $workingDirectory/src/init/inst-functions.sh \
          --replace-warn "WAZUH_GROUP='wazuh'" "WAZUH_GROUP='nixbld'" \
          --replace-warn "WAZUH_USER='wazuh'" "WAZUH_USER='nixbld'"

        cd $workingDirectory # Must run install from src
        INSTALLDIR=$out USER_DIR=$out ./install.sh binary-install

        chmod u+x $out/bin/* $out/active-response/bin/*
        rm -rf $out/src # Remove src
      '';
    };
in
{
  environment.systemPackages = [ pkg ];

  users.users.${ wazuhUser } = {
    isSystemUser = true;
    group = wazuhGroup;
    description = "Wazuh daemon user";
    home = stateDir;
  };

  users.groups.${ wazuhGroup } = { };

  systemd.tmpfiles.rules = [
    "d ${stateDir} 0750 ${wazuhUser} ${wazuhGroup}"
  ];

  systemd.services.wazuh-agent = {
    path = [
      "/run/current-system/sw"
    ];
    description = "Wazuh agent";
    wants = [ "network-online.target" ];
    after = [ "network.target" "network-online.target" ];
    wantedBy = [ "multi-user.target" ];

    preStart = ''
      rsync -av --exclude '/etc/client.keys' --exclude '/logs/' ${pkg}/ ${stateDir}/
      cp ${agentConfig} ${stateDir}/etc/ossec.conf

      find ${stateDir} -type f -exec chmod 644 {} \;
      find ${stateDir} -type d -exec chmod 750 {} \;
      chmod u+x ${stateDir}/bin/*
      chmod u+x ${stateDir}/active-response/bin/*
      chown -R ${wazuhUser}:${wazuhGroup} ${stateDir}
    '';

    serviceConfig = {
      Type = "forking";
      WorkingDirectory = stateDir;
      ExecStart = "${stateDir}/bin/wazuh-control start";
      ExecStop = "${stateDir}/bin/wazuh-control stop";
      ExecReload = "${stateDir}/bin/wazuh-control reload";
      KillMode = "process";
      RemainAfterExit = "yes";
    };
  };
}
