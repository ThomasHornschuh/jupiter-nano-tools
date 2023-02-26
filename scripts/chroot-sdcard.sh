#!/bin/bash                                                                                                                                 
# restart script with root privileges if not already
[ "$UID" -eq 0 ] || exec sudo "$0" "$@" ]



# Mount SD Card Partiton 2
rootfs_dir="/media/thomas/rootfs"
#mdkir ${rootfs_dir}
#mount /dev/sdb2 ${rootfs_dir}

echo "Copy qemu"
cp /usr/bin/qemu-arm-static ${rootfs_dir}/usr/bin/

echo "mounting special filesystems"
mount -t tmpfs run "${rootfs_dir}/run"
mount -t sysfs sysfs "${rootfs_dir}/sys"
mount -t proc proc "${rootfs_dir}/proc"
mkdir -p ${rootfs_dir}/dev/pts
mount -t devpts devpts "${rootfs_dir}/dev/pts"

echo "Chroot"
chroot "${rootfs_dir}" /bin/bash
echo "Cleaning up"
sync


umount -fl "${rootfs_dir}/dev/pts"
umount -fl "${rootfs_dir}/proc"
umount -fl "${rootfs_dir}/sys"
umount -fl "${rootfs_dir}/run"
echo "Finish umounts"

echo "Deleting qemu"
rm ${rootfs_dir}/usr/bin/qemu-arm-static
#umount /dev/sdb2

#rmdir ${rootfs_dir}