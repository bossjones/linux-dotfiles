#!/usr/bin/env bash

# SOURCE: https://theboostapps.com/tiktok-video-length-video-formatting-guide/#:~:text=Dimensions%3A%20TikTok%20video%20dimensions%20should,File%20type%3A%20TikTok%20supports%20.
# https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/
# set -euox pipefail
set -e

# NOTE: Scaling up an image to have padded space between top and bottom is call letterboxing.
# NOTE: Scaling up an image to have padded space between left and right is call pillarboxing.

# https://gist.github.com/jonsuh/3c89c004888dfc7352be
# ----------------------------------
# Colors
# ----------------------------------
export NOCOLOR='\033[0m'
export RED='\033[0;31m'
export GREEN='\033[0;32m'
export ORANGE='\033[0;33m'
export BLUE='\033[0;34m'
export PURPLE='\033[0;35m'
export CYAN='\033[0;36m'
export LIGHTGRAY='\033[0;37m'
export DARKGRAY='\033[1;30m'
export LIGHTRED='\033[1;31m'
export LIGHTGREEN='\033[1;32m'
export YELLOW='\033[1;33m'
export LIGHTBLUE='\033[1;34m'
export LIGHTPURPLE='\033[1;35m'
export LIGHTCYAN='\033[1;36m'
export WHITE='\033[1;37m'

export awk_bin="$(which gawk)"
export sed_bin="$(which gsed)"

while getopts ":hf:" opt; do
  case ${opt} in
    h ) # process option h
      ;;
    f ) # process option f
      filename_val=$OPTARG
      ;;
    \? )
      echo "Invalid option: $OPTARG" 1>&2
      ;;
    : )
      echo "Invalid option: $OPTARG requires an argument" 1>&2
      ;;
  esac
done

export input_file="${filename_val}"
export full_path_input_file="$(pwd)/${filename_val}"
export full_path_output_file="tiktok-$(uuidgen).mp4"
export font_location='/Volumes/Macintosh HD/System/Library/Fonts/Helvetica.ttc'

tmpfile=$(mktemp /tmp/abc-script.XXXXXX)
echo -e " ${BLUE}[ffmpeg-tiktok]${NOCOLOR} tmpfile=${tmpfile}"
echo -e " ${BLUE}[ffmpeg-tiktok]${NOCOLOR} will set the width of the output image to 1920 pixels and will calculate the height of the output image according to the aspect ratio of the input video."

# # https://superuser.com/questions/547296/resizing-videos-with-ffmpeg-avconv-to-fit-into-static-sized-player
# # https://superuser.com/questions/690021/video-padding-using-ffmpeg/690211
# cat << EOF > "${tmpfile}"
# # dimensions=\$(echo "\$(ffprobe -v error -select_streams v:0 -show_entries stream=width,height -of csv=s=x:p=0 ${full_path_input_file})" | $awk_bin 'BEGIN {FS="x"} {print int(\$1/4)"x"int(\$2/4)}' | tee /tmp/dimensions.txt)

# # echo -e " ${BLUE}[ffmpeg-watermark]${NOCOLOR} dimensions=\$(\head -1 /tmp/dimensions.txt)"

# # echo -e " ${BLUE}[ffmpeg-watermark]${NOCOLOR} dimensions=\$(\head -1 /tmp/dimensions.txt | cut -d"x" -f1):-1"

# # # ffmpeg -i ${full_path_input_file} -vf scale=1920:-2,setdar=9:16 ${full_path_output_file}

# # # scale=w=-2:h=1082:force_original_aspect_ratio=decrease
# # ffmpeg -i ${full_path_input_file} -vf scale=h=1082:force_original_aspect_ratio=decrease ${full_path_output_file}

# ffmpeg -ss 00:02:00.0 -i ${full_path_input_file} -t 00:00:59.0 -filter:v 'crop=9/16*in_h:in_h' ${full_path_output_file}


#########################################################################################################################
# 11.36 crop
# Crop the input video to given dimensions.
# SOURCE: https://ffmpeg.org/ffmpeg-filters.html#scale-1

# It accepts the following parameters:

# w, out_w
# The width of the output video. It defaults to iw. This expression is evaluated only once during the filter configuration, or when the 'w' or 'out_w' command is sent.

# h, out_h
# The height of the output video. It defaults to ih. This expression is evaluated only once during the filter configuration, or when the 'h' or 'out_h' command is sent.

# x
# The horizontal position, in the input video, of the left edge of the output video. It defaults to (in_w-out_w)/2. This expression is evaluated per-frame.

# y
# The vertical position, in the input video, of the top edge of the output video. It defaults to (in_h-out_h)/2. This expression is evaluated per-frame.

# keep_aspect
# If set to 1 will force the output display aspect ratio to be the same of the input, by changing the output sample aspect ratio. It defaults to 0.

# exact
# Enable exact cropping. If enabled, subsampled videos will be cropped at exact width/height/x/y as specified and will not be rounded to nearest smaller value. It defaults to 0.

# The out_w, out_h, x, y parameters are expressions containing the following constants:

# x
# y
# The computed values for x and y. They are evaluated for each new frame.

# in_w
# in_h
# The input width and height.

# iw
# ih
# These are the same as in_w and in_h.

# out_w
# out_h
# The output (cropped) width and height.

# ow
# oh
# These are the same as out_w and out_h.

# a
# same as iw / ih

# sar
# input sample aspect ratio

# dar
# input display aspect ratio, it is the same as (iw / ih) * sar

# hsub
# vsub
# horizontal and vertical chroma subsample values. For example for the pixel format "yuv422p" hsub is 2 and vsub is 1.

# n
# The number of the input frame, starting from 0.

# pos
# the position in the file of the input frame, NAN if unknown

# t
# The timestamp expressed in seconds. It's NAN if the input timestamp is unknown.

# The expression for out_w may depend on the value of out_h, and the expression for out_h may depend on out_w, but they cannot depend on x and y, as x and y are evaluated after out_w and out_h.

# The x and y parameters specify the expressions for the position of the top-left corner of the output (non-cropped) area. They are evaluated for each frame. If the evaluated value is not valid, it is approximated to the nearest valid value.

# The expression for x may depend on y, and the expression for y may depend on x.
#########################################################################################################################

# EXAMPLE: ok we have the following
# input: 244 × 174
# output: 1080 × 1920


# # rm /tmp/dimensions.txt
# EOF
# https://superuser.com/questions/547296/resizing-videos-with-ffmpeg-avconv-to-fit-into-static-sized-player
# https://superuser.com/questions/690021/video-padding-using-ffmpeg/690211
# https://github.com/jackliston1998/project-jimin/blob/217c593f873331c01c81daa7fc232433ea9efd13/editor.py
# https://stackoverflow.com/questions/54526345/ffmpeg-how-to-move-the-video-without-stretching-it
cat << EOF > "${tmpfile}"
# ffmpeg -i ${full_path_input_file} -filter:v 'crop=9/16*in_h:in_h' ${full_path_output_file}
# ffmpeg -i ${full_path_input_file} -filter:v "crop=640:360:0:(in_h-out_h)/2 +((in_h-out_h)/2)*sin(t),scale=640:360" ${full_path_output_file}

# ffmpeg -i ${full_path_input_file} -filter:v "crop=1280:720:0:(in_h-out_h)/2 +((in_h-out_h)/2)*sin(t)" -y ${full_path_output_file}

ffmpeg -i ${full_path_input_file} -vf "scale=1080:1920:force_original_aspect_ratio=decrease,pad=1080:1920:-1:-1:color=white" ${full_path_output_file}
EOF




echo -e " ${BLUE}[ffmpeg-tiktok]${NOCOLOR} cat ${tmpfile}"
cat "${tmpfile}"

bash -x "${tmpfile}"

rm "$tmpfile"



---------------------------


# generate a common name when one isn't passed in from outside the script
if [[ x"$common_name" = x"" ]]; then
    echo -e " ${BLUE}[ffmpeg-tiktok]${NOCOLOR} common_name='is empty'"
    export input_file="${filename_val}"
    export full_path_input_file="$(pwd)/${input_file}"
    export get_extension=$(basename -- $input_file | cut -d"." -f2)
    export fname_common="$(uuidgen).${get_extension}"
    export full_path_input_file="${fname_common}"
    export full_path_output_file="tiktok-${fname_common}"
    # export full_path_input_file="$(pwd)/${fname_common}"
else
    echo -e " ${BLUE}[ffmpeg-tiktok]${NOCOLOR} common_name='set', overriding variable names"
    export input_file="${filename_val}"
    export full_path_input_file="$(pwd)/${input_file}"
    export get_extension=$(basename -- $input_file | cut -d"." -f2)
    export fname_common="${common_name}"
    export full_path_output_file="tiktok-${fname_common}"
fi
export font_location='/Volumes/Macintosh HD/System/Library/Fonts/Helvetica.ttc'

tmpfile=$(mktemp /tmp/abc-script.XXXXXX)
echo -e " ${BLUE}[ffmpeg-tiktok]${NOCOLOR} tmpfile=${tmpfile}"
echo -e " ${BLUE}[ffmpeg-tiktok]${NOCOLOR} will set the width of the output image to 1920 pixels and will calculate the height of the output image according to the aspect ratio of the input video."

# https://superuser.com/questions/547296/resizing-videos-with-ffmpeg-avconv-to-fit-into-static-sized-player
# https://superuser.com/questions/690021/video-padding-using-ffmpeg/690211
# https://github.com/jackliston1998/project-jimin/blob/217c593f873331c01c81daa7fc232433ea9efd13/editor.py
# https://stackoverflow.com/questions/54526345/ffmpeg-how-to-move-the-video-without-stretching-it
cat << EOF > "${tmpfile}"
# ffmpeg -i ${full_path_input_file} -filter:v 'crop=9/16*in_h:in_h' ${full_path_output_file}
# ffmpeg -i ${full_path_input_file} -filter:v "crop=640:360:0:(in_h-out_h)/2 +((in_h-out_h)/2)*sin(t),scale=640:360" ${full_path_output_file}

# ffmpeg -i ${full_path_input_file} -filter:v "crop=1280:720:0:(in_h-out_h)/2 +((in_h-out_h)/2)*sin(t)" -y ${full_path_output_file}


echo -e " ${GREEN}[ffmpeg-tiktok]${NOCOLOR} ${CYAN}tiktok${NOCOLOR} video ${YELLOW}1080:1920 (1080 x 1920px)${NOCOLOR}"
ffmpeg -hide_banner -loglevel warning -i ${full_path_input_file} -vf "scale=1080:1920:force_original_aspect_ratio=decrease,pad=1080:1920:-1:-1:color=white" ${full_path_output_file}
EOF

echo -e " ${BLUE}[ffmpeg-tiktok]${NOCOLOR} cat ${tmpfile}"
cat "${tmpfile}"

bash "${tmpfile}"

rm "$tmpfile"
