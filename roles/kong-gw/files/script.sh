#!/bin/bash
cd /home/kong
export RESTY_VERSION=$(grep -oP 'RESTY_VERSION=\K.*' .requirements)
export RESTY_OPENSSL_VERSION=$(grep -oP 'RESTY_OPENSSL_VERSION=\K.*' .requirements)
export RESTY_LUAROCKS_VERSION=$(grep -oP 'RESTY_LUAROCKS_VERSION=\K.*' .requirements)
export RESTY_PCRE_VERSION=$(grep -oP 'RESTY_PCRE_VERSION=\K.*' .requirements)
export BUILDROOT=$(realpath ~/kong-dep)
mkdir ${BUILDROOT} -p
cd ../
git clone https://github.com/kong/kong-build-tools
cd kong-build-tools/openresty-build-tools
./kong-ngx-build -p ${BUILDROOT} \
  --openresty ${RESTY_VERSION} \
  --openssl ${RESTY_OPENSSL_VERSION} \
  --luarocks ${RESTY_LUAROCKS_VERSION} \
  --pcre ${RESTY_PCRE_VERSION}
export OPENSSL_DIR=${BUILDROOT}/openssl
export CRYPTO_DIR=${BUILDROOT}/openssl
export PATH=${BUILDROOT}/luarocks/bin:${BUILDROOT}/openresty/bin:${PATH}
eval $(luarocks path)
echo export OPENSSL_DIR=${BUILDROOT}/openssl >> ~/.profile
echo export PATH=${BUILDROOT}/luarocks/bin:${BUILDROOT}/openresty/bin:\${PATH} >> ~/.profile
echo eval "\$(luarocks path)" >> ~/.profile
cd /home/kong
luarocks make
make dev
export PATH=$PATH:/root/kong-dep/openresty/nginx/sbin
export PATH=$PATH:/home/kong/bin/
