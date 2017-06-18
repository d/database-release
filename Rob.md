# An idiot's guide to running Greenplum on BOSH


### Prerequisite
1. Docker

    - (Recommended) [Run Docker Machine in VMware Fusion](https://github.com/d/bug-free-fortnight/blob/develop/VMware_Fusion.md)
    - If you choose Docker for Mac, run `brew cask install docker`

1. BOSH CLI v2
    ```
    brew install cloudfoundry/tap/bosh-cli
    ```
    This will install an executable `bosh2`. The `2` at the end is for historical reason, to avoid possible conflict with a previous incarnation of the Ruby-based BOSH CLI v1.

### Steps
1. Get a BOSH director. The quickest way is to run [bosh-lite](https://bosh.io/docs/bosh-lite.html) in Docker:
    ```
    docker run --name bosh --detach -ti -p 25555:25555 --privileged bosh/bosh-lite /usr/bin/start-bosh
    ```

1. Clone the bosh-lite repo because we'll want to use its certificate authority public key
    ```
    git clone https://github.com/cloudfoundry/bosh-lite ~/workspace/bosh-lite
    ```

1. Clone this repo:
    ```
    git clone https://github.com/d/database-release ~/workspace/database-release
    git -C ~/workspace/database-release submodule update --init
    ```

1. Authenticate with the BOSH director
    ```
    bosh2 --environment 127-0-0-1.sslip.io --ca-cert ~/workspace/bosh-lite/ca/certs/ca.crt alias-env lite
    bosh2 --environment lite --client=admin --client-secret=admin login
    ```

1. Upload a stemcell and set a cloud-config
    ```
    bosh2 --environment lite upload-stemcell https://bosh.io/d/stemcells/bosh-warden-boshlite-ubuntu-trusty-go_agent
    bosh2 --environment lite update-cloud-config manifests/warden.yml
    ```

1. Deploy!
    ```
    bosh2 create-release --force
    bosh2 --environment lite update-release
    bosh2 --environment lite --deployment gpdb_local --non-interactive deploy manifests/manifest.yml
    ```

1. Try using the database
    ```
    docker run --rm -ti --net container:bosh postgres:8 psql -h 10.244.0.2 -U vcap -d postgres
    ```

## Footnote
Greenplum is a trademark of Pivotal Software, Inc. in the U.S. and other countries.
