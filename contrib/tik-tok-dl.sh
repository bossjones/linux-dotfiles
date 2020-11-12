#!/usr/bin/env bash

dl(){
    /usr/local/bin/youtube-dl -o "$(uuidgen).%(ext)s" "${1}"
}
dl-best(){
    /usr/local/bin/youtube-dl -o "$(uuidgen).%(ext)s" -f $(/usr/local/bin/youtube-dl -o "$(uuidgen).%(ext)s" -F "${1}" | grep best | grep mp4 | head -1 | awk '{print $1}') "${1}"
}
dl-mp3(){
    /usr/local/bin/youtube-dl -o "$(uuidgen).%(ext)s" --extract-audio --audio-format mp3 "${1}"
}

dl-echo(){
  echo " [running] dl-best $1"
  dl-best $1
  sleep 20
}

mkdir-scenedetect(){
  echo " [running] scenedetect -i $1 detect-content split-video"
  export _FOLDER=$(echo $1 | cut -d. -f1)
  mkdir -p ~/Downloads/ghetto_tiktok/${_FOLDER} || true
  mv -fv ~/Downloads/ghetto_tiktok/$1 ~/Downloads/ghetto_tiktok/${_FOLDER}/
  pushd ~/Downloads/ghetto_tiktok/${_FOLDER}
  scenedetect -i $1 detect-content split-video
  popd
}

mkdir -p ~/Downloads/ghetto_tiktok || true
pushd ~/Downloads/ghetto_tiktok
# dl-echo https://www.youtube.com/watch?v=MEECVlQHAjI
# dl-echo https://www.youtube.com/watch?v=j3uC_q-yYAE
# dl-echo https://www.youtube.com/watch?v=WhZQ1Ya-NMo
# dl-echo https://www.youtube.com/watch?v=b65XM13vPNI
# dl-echo https://www.youtube.com/watch?v=_l0irqTpgi0
# dl-echo https://www.youtube.com/watch?v=DkniZxgEUHs
# dl-echo https://www.youtube.com/watch?v=w6DSGRCig94
# dl-echo https://www.youtube.com/watch?v=NIoihRnbMrM
# dl-echo https://www.youtube.com/watch?v=iUlhVwjDWg4
# dl-echo https://www.youtube.com/watch?v=Lu-CulFf4HQ
# dl-echo https://www.youtube.com/watch?v=_0MZpS0IpVc
# dl-echo https://www.youtube.com/watch?v=aCCZos5Y9gM
# dl-echo https://www.youtube.com/watch?v=qQDEX6qoEIg
# dl-echo https://www.youtube.com/watch?v=M7QIkNhjyj0
# dl-echo https://www.youtube.com/watch?v=Y30bwuxEMCc
# dl-echo https://www.youtube.com/watch?v=QpFjSfWYctw
# dl-echo https://www.youtube.com/watch?v=KkkmenaddeY
# dl-echo https://www.youtube.com/watch?v=YTGoN6G_JAA
# dl-echo https://www.youtube.com/watch?v=Ysj4LUJ6_y0
popd

mkdir-scenedetect 3FD6DE26-3445-40EC-AE81-092EBB2533D5.mp4
mkdir-scenedetect A7BE88D4-D137-4ABE-9501-BCFCAD7EB196.mp4
mkdir-scenedetect 59B0B9C9-54CB-49CC-9005-3A1C964680E9.mp4
mkdir-scenedetect F162EF8E-7D1A-4AB0-BC70-5CCAE3A98927.mp4
mkdir-scenedetect 47EEA73C-B75F-428B-AD25-C9BDC4831AD5.mp4
mkdir-scenedetect 159C177A-4928-45EE-8A13-215B7E0D1146.mp4
mkdir-scenedetect 3B03DD26-655F-4154-A8BA-83D79FF25DE2.mp4
mkdir-scenedetect 2A637232-3E2E-4F15-9504-CBC5AB50D1E6.mp4
mkdir-scenedetect 5F77DD27-A80C-4ADA-A546-3E88AF0D82FD.mp4
mkdir-scenedetect EC73ECB5-2426-4921-A815-BF37B408CBDD.mp4
mkdir-scenedetect B8559E1C-2ECB-43AA-BE8E-64A438990634.mp4
mkdir-scenedetect 3365AA79-FA75-42F6-845B-FDCB3AAB5AEA.mp4
mkdir-scenedetect A885F611-07A4-4332-9E36-BEFD555BEDCA.mp4
mkdir-scenedetect 0998799B-D5F0-4A69-AC9F-69291149DB72.mp4
mkdir-scenedetect 1BC1F4EE-8231-4540-AF8D-F554BD31AF33.mp4
mkdir-scenedetect 69EDEC18-C86E-450C-B1FA-70F529E889E2.mp4
mkdir-scenedetect D045B512-15A6-4F6D-A397-976BBCE32CF5.mp4
mkdir-scenedetect 7CDA6E77-3DFD-423E-BB33-97B05F31AF72.mp4
