debconf-utils:
  pkg.installed

# Make sure open java is not present as it have issue with ssl
prevent_openjdk_present:
  pkg.purged:
    - name: openjdk-{{ pillar['java']['version'] }}-jdk

java_ppa_repo:
  pkgrepo.managed:
    - ppa: webupd8team/java


oracle-java-license-autoaccept:
  debconf.set:
    - name: oracle-java{{ pillar['java']['version'] }}-installer
    - data:
        'shared/accepted-oracle-license-v1-1': {'type': 'boolean', 'value': True}
    - require:
      - pkg: debconf-utils
    - require_in:
      - pkg: java_pkgs


java_pkgs:
  pkg.installed:
    - pkgs:
      - oracle-java{{ pillar['java']['version'] }}-installer
      - oracle-java{{ pillar['java']['version'] }}-set-default
      - ant

# Remove previously set java env
/etc/profile.d/java.sh:
  file.absent
