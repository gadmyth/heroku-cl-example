version=`dpkg -f $1 | grep Version`
size="Size: "`ls -l $1 | cut -f 5 -d " "`
md5="MD5sum: "`md5sum $1 | cut -f 1 -d " "`
sha1="SHA1: "`sha1sum $1 | cut -f 1 -d " "`
sha256="SHA256: "`sha256sum $1 | cut -f 1 -d " "`
echo $version
echo $size
echo $md5
echo $sha1
echo $sha256

sed -i -e "s/Version.*/${version}/" Release

sed -i -e "s/Size.*/${size}/" Packages
sed -i -e "s/Version.*/${version}/" Packages
sed -i -e "s/MD5sum.*/${md5}/" Packages
sed -i -e "s/SHA1.*/${sha1}/" Packages
sed -i -e "s/SHA256.*/${sha256}/" Packages

gzip -k -f Packages
bzip2 -k -f Packages
