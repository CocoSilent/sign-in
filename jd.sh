#!/usr/bin/env bash

## 路径
ShellDir=${JD_DIR:-$(cd $(dirname $0); pwd)}
[ ${JD_DIR} ] && HelpJd=jd || HelpJd=jd.sh
ScriptsDir=${ShellDir}/scripts
ConfigDir=${ShellDir}/config
FileConf=${ConfigDir}/config.sh
FileConfSample=${ShellDir}/sample/config.sh.sample
LogDir=${ShellDir}/log
ListScripts=($(cd ${ScriptsDir}; ls *.js | grep -E "j[drx]_"))
ListCron=${ConfigDir}/crontab.list

## 导入config.sh
function Import_Conf {
  if [ -f ${FileConf} ]
  then
    . ${FileConf}
    if [ -z "${Cookie1}" ]; then
      echo -e "请先在config.sh中配置好Cookie...\n"
      exit 1
    fi
  else
    echo -e "配置文件 ${FileConf} 不存在，请先按教程配置好该文件...\n"
    exit 1
  fi
}

## 更新crontab
function Detect_Cron {
  if [[ $(cat ${ListCron}) != $(crontab -l) ]]; then
    crontab ${ListCron}
  fi
}

## 用户数量UserSum
function Count_UserSum {
  for ((i=1; i<=1000; i++)); do
    Tmp=Cookie$i
    CookieTmp=${!Tmp}
    [[ ${CookieTmp} ]] && UserSum=$i || break
  done
}

## 组合Cookie和互助码子程序
function Combin_Sub {
  CombinAll=""
  for ((i=1; i<=${UserSum}; i++)); do
    for num in ${TempBlockCookie}; do
      if [[ $i -eq $num ]]; then
        continue 2
      fi
    done
    Tmp1=$1$i
    Tmp2=${!Tmp1}
    case $# in
      1)
        CombinAll="${CombinAll}&${Tmp2}"
        ;;
      2)
        CombinAll="${CombinAll}&${Tmp2}@$2"
        ;;
      3)
        if [ $(($i % 2)) -eq 1 ]; then
          CombinAll="${CombinAll}&${Tmp2}@$2"
        else
          CombinAll="${CombinAll}&${Tmp2}@$3"
        fi
        ;;
      4)
        case $(($i % 3)) in
          1)
            CombinAll="${CombinAll}&${Tmp2}@$2"
            ;;
          2)
            CombinAll="${CombinAll}&${Tmp2}@$3"
            ;;
          0)
            CombinAll="${CombinAll}&${Tmp2}@$4"
            ;;
        esac
        ;;
    esac
  done
  echo ${CombinAll} | perl -pe "{s|^&||; s|^@+||; s|&@|&|g; s|@+|@|g}"
}

## 组合Cookie、Token与互助码
function Combin_All {
  export JD_COOKIE=$(Combin_Sub Cookie)
  #东东农场(jd_fruit.js)
  export FRUITSHARECODES=$(Combin_Sub ForOtherFruit "7fe1bd0e97304be8bf79205fe90cb0b4@158d6092ed794fe687d4fcb97188c3bf@158d6092ed794fe687d4fcb97188c3bf")
  #东东萌宠(jd_pet.js)
  export PETSHARECODES=$(Combin_Sub ForOtherPet "MTEyNTEyNTE1MDAwMDAwMDA0Nzc0MzkzMQ==@MTE0MDkyMjEwMDAwMDAwNDg4MDIyNjk=@MTEyNTEyNTE1MDAwMDAwMDA0Nzc0MzkzMQ==")
  #种豆得豆(jd_plantBean.js)
  export PLANT_BEAN_SHARECODES=$(Combin_Sub ForOtherBean "lhubofhlunfav4x3c2kulfr5fe5ac3f4ijdgqji@mlrdw3aw26j3xeyisgkq6jnomiddkisbrkwv2sy@lhubofhlunfav4x3c2kulfr5fe5ac3f4ijdgqji")
  #京喜工厂(jd_dreamFactory.js)
  export DREAM_FACTORY_SHARE_CODES=$(Combin_Sub ForOtherDreamFactory "lvEaJR6i5kfkyTPiblul3A==@9MZn-oj6rttgkHcSOZC9bg==@lvEaJR6i5kfkyTPiblul3A==")
  #东东工厂(jd_jdfactory.js)
  export DDFACTORY_SHARECODES=$(Combin_Sub ForOtherJdFactory "T0169qQiH11IrAiSfnWpCjVWnYaS5kRrbA@T0225KkcRRZK9FyFc0vylvBfdQCjVWnYaS5kRrbA")
  #京东赚赚(jd_jdzz.js)
  export JDZZ_SHARECODES=$(Combin_Sub ForOtherJdzz "S9qQiH11IrAiSfnWp@S5KkcRRZK9FyFc0vylvBfdQ@S5KkcRRZK9FyFc0vylvBfdQ")
  #crazyJoy(jd_crazy_joy.js)
  export JDJOY_SHARECODES=$(Combin_Sub ForOtherJoy "XeHcyVr3btHJ-zxajRqmbw==@c2MDuHs7IxQ-DTIBJ9HW8qt9zd5YaBeE")
  #惊喜农场(jd_jxnc.js)
  export JXNC_SHARECODES=$(Combin_Sub ForOtherJxnc)
  #口袋书店(jd_bookshop.js)
  export BOOKSHOP_SHARECODES=$(Combin_Sub ForOtherBookShop "6b7d17c29d4e4f49a6335ee80157c455@c858f02a64094665ad7552721794ba2b@234f539da0824491befb23529dcdaa59")
  #签到领现金(jd_cash.js)
  export JD_CASH_SHARECODES=$(Combin_Sub ForOtherCash "a0JmM6_jP6BjrwGI@9rqvuWU9sE-2@eU9YaeThZ_R0oj_TyXRG1w")
  #闪购盲盒(jd_sgmh.js)
  export JDSGMH_SHARECODES=$(Combin_Sub ForOtherSgmh "T0169qQiH11IrAiSfnWpCjVQmoaT5kRrbA@T0225KkcRRZK9FyFc0vylvBfdQCjVQmoaT5kRrbA@T012a1zrlZeWI-dHCjVQmoaT5kRrbA")
  #惊喜财富岛(jd_cfd.js)
  export JDCFD_SHARECODES=$(Combin_Sub ForOtherJdcfd "66C8B312B4514DD409E1312C489201D688F442E9DBC9EF1531F6D0587D87CB44@C9A556AF8065423595A1D57450BA5509F3DCD8EC249A2FC6D3CD521D2FEB231A@A6F67E22586A210AE6887B3DD522736630C9DBF062A66168B2C5315F99D1ABD7@D0B8B8ECA098E7B19850BB90DFA24CD426FA7D28C89B0F506745BA17099ED5E4")
  #东东健康社区(jd_health.js)
  export JDHEALTH_SHARECODES=$(Combin_Sub ForOtherHealth "T022u_x3QRke_EnVIR_wnPEIcQCjVfnoaW5kRrbA@T012a1zrlZeWI-dHCjVfnoaW5kRrbA@T0205KkcHkJujwKkXXy9wK9NCjVfnoaW5kRrbA")
    #城城领现金(jd_city.js)
  export CITY_SHARECODES=$(Combin_Sub ForOtherCity "VNy0l6_1GFbmIOzHW5h_1k1H_BNo3s-mVdCxzI2luC32@RtGKzeT3QALxLdKcFdNm1zTsoCfYds5iBJKXw0quAzQKvH6tsA@QMyKkLX_EEj6OdzWW5gzmmvH5PtiKTrbMXHrZ-VTRm4")
  #手机狂欢城(jd_carnivalcity.js)
  export JD818_SHARECODES=$(Combin_Sub ForOtherCarni "2ad4df7a-b55c-469f-bc29-ba81722f82b3@2fc79002-18eb-4ed0-9b5d-99d9daa85dbf@07741755-758a-4f07-bca7-96dbb4b5a556@2f4aaab3-32c0-47ec-90a6-4aa5f5aa339d")
  
}

## 转换JD_BEAN_SIGN_STOP_NOTIFY或JD_BEAN_SIGN_NOTIFY_SIMPLE
function Trans_JD_BEAN_SIGN_NOTIFY {
  case ${NotifyBeanSign} in
    0)
      export JD_BEAN_SIGN_STOP_NOTIFY="true"
      ;;
    1)
      export JD_BEAN_SIGN_NOTIFY_SIMPLE="true"
      ;;
  esac
}

## 转换UN_SUBSCRIBES
function Trans_UN_SUBSCRIBES {
  export UN_SUBSCRIBES="${goodPageSize}\n${shopPageSize}\n${jdUnsubscribeStopGoods}\n${jdUnsubscribeStopShop}"
}

## 申明全部变量
function Set_Env {
  Count_UserSum
  Combin_All
  Trans_JD_BEAN_SIGN_NOTIFY
  Trans_UN_SUBSCRIBES
}

## 随机延迟
function Random_Delay {
  if [[ -n ${RandomDelay} ]] && [[ ${RandomDelay} -gt 0 ]]; then
    CurMin=$(date "+%-M")
    if [[ ${CurMin} -gt 2 && ${CurMin} -lt 30 ]] || [[ ${CurMin} -gt 31 && ${CurMin} -lt 59 ]]; then
      CurDelay=$((${RANDOM} % ${RandomDelay} + 1))
      echo -e "\n命令未添加 \"now\"，随机延迟 ${CurDelay} 秒后再执行任务，如需立即终止，请按 CTRL+C...\n"
      sleep ${CurDelay}
    fi
  fi
}

## 使用说明
function Help {
  echo -e "本脚本的用法为："
  echo -e "1. bash ${HelpJd} xxx      # 如果设置了随机延迟并且当时时间不在0-2、30-31、59分内，将随机延迟一定秒数"
  echo -e "2. bash ${HelpJd} xxx now  # 无论是否设置了随机延迟，均立即运行"
  echo -e "3. bash ${HelpJd} hangup   # 重启挂机程序"
  echo -e "4. bash ${HelpJd} resetpwd # 重置控制面板用户名和密码"
  echo -e "\n针对用法1、用法2中的\"xxx\"，无需输入后缀\".js\"，另外，如果前缀是\"jd_\"的话前缀也可以省略。"
  echo -e "当前有以下脚本可以运行（仅列出以jd_、jr_、jx_开头的脚本）："
  cd ${ScriptsDir}
  for ((i=0; i<${#ListScripts[*]}; i++)); do
    Name=$(grep "new Env" ${ListScripts[i]} | awk -F "'|\"" '{print $2}')
    echo -e "$(($i + 1)).${Name}：${ListScripts[i]}"
  done
}

## nohup
function Run_Nohup {
  for js in ${HangUpJs}
  do
    if [[ $(ps -ef | grep "${js}" | grep -v "grep") != "" ]]; then
      ps -ef | grep "${js}" | grep -v "grep" | awk '{print $2}' | xargs kill -9
    fi
  done

  for js in ${HangUpJs}
  do
    [ ! -d ${LogDir}/${js} ] && mkdir -p ${LogDir}/${js}
    LogTime=$(date "+%Y-%m-%d-%H-%M-%S")
    LogFile="${LogDir}/${js}/${LogTime}.log"
    nohup node ${js}.js > ${LogFile} &
  done
}

## pm2
function Run_Pm2 {
  pm2 flush
  for js in ${HangUpJs}
  do
    pm2 restart ${js}.js || pm2 start ${js}.js
  done
}

## 运行挂机脚本
function Run_HangUp {
  Import_Conf $1 && Detect_Cron && Set_Env
  HangUpJs="jd_crazy_joy_coin"
  cd ${ScriptsDir}
  if type pm2 >/dev/null 2>&1; then
    Run_Pm2 2>/dev/null
  else
    Run_Nohup >/dev/null 2>&1
  fi
}

## 重置密码
function Reset_Pwd {
  cp -f ${ShellDir}/sample/auth.json ${ConfigDir}/auth.json
  echo -e "控制面板重置成功，用户名：admin，密码：adminadmin\n"
}

## 运行京东脚本
function Run_Normal {
  Import_Conf $1 && Detect_Cron && Set_Env
  
  FileNameTmp1=$(echo $1 | perl -pe "s|\.js||")
  FileNameTmp2=$(echo $1 | perl -pe "{s|jd_||; s|\.js||; s|^|jd_|}")
  SeekDir="${ScriptsDir} ${ScriptsDir}/backUp ${ConfigDir}"
  FileName=""
  WhichDir=""

  for dir in ${SeekDir}
  do
    if [ -f ${dir}/${FileNameTmp1}.js ]; then
      FileName=${FileNameTmp1}
      WhichDir=${dir}
      break
    elif [ -f ${dir}/${FileNameTmp2}.js ]; then
      FileName=${FileNameTmp2}
      WhichDir=${dir}
      break
    fi
  done
  
  if [ -n "${FileName}" ] && [ -n "${WhichDir}" ]
  then
    [ $# -eq 1 ] && Random_Delay
    LogTime=$(date "+%Y-%m-%d-%H-%M-%S")
    LogFile="${LogDir}/${FileName}/${LogTime}.log"
    [ ! -d ${LogDir}/${FileName} ] && mkdir -p ${LogDir}/${FileName}
    cd ${WhichDir}
    node ${FileName}.js | tee ${LogFile}
  else
    echo -e "\n在${ScriptsDir}、${ScriptsDir}/backUp、${ConfigDir}三个目录下均未检测到 $1 脚本的存在，请确认...\n"
    Help
  fi
}

## 命令检测
case $# in
  0)
    echo
    Help
    ;;
  1)
    if [[ $1 == hangup ]]; then
      Run_HangUp
    elif [[ $1 == resetpwd ]]; then
      Reset_Pwd
    else
      Run_Normal $1
    fi
    ;;
  2)
    if [[ $2 == now ]]; then
      Run_Normal $1 $2
    else
      echo -e "\n命令输入错误...\n"
      Help
    fi
    ;;
  *)
    echo -e "\n命令过多...\n"
    Help
    ;;
esac
