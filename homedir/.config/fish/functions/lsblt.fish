function lsblt --wraps='lsblk -o NAME,FSTYPE,SIZE,MOUNTPOINT' --description 'alias lsblt=lsblk -o NAME,FSTYPE,SIZE,MOUNTPOINT'
  lsblk -o NAME,FSTYPE,SIZE,MOUNTPOINT $argv
        
end
