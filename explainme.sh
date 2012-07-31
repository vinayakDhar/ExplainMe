#!/bin/sh
# Explain Me 
# Intial Draft
# Tokenize command and explain in plain english
#

PARAMS=${@}


print_brackets(){
  echo "(" $@ ")"
}

tokenize(){
  for i in ${@} 
  do
#    echo $i
    token_type $i  
  done
}

get_details_command(){
  apropos $1 | grep -e "^$1 " | head -1 | tr -s ' ' | cut -d '-' -f2


}

get_details_switch(){
  SWITCH=-$1
  INFO=`man ${COMMAND_STACK[$PIPES]} | grep -e "  $SWITCH" -A 1`
#  if [ -z "$INFO" ]; then
#    echo "fetch 2nd time"
#    INFO=`man ${COMMAND_STACK[$PIPES]} | grep -e "  $SWITCH"`
#    echo $INFO
#  fi
  echo $INFO
}


tokenize_switch_char(){
  SWITCHES=${1:1}
  for i in `seq ${#SWITCHES}`
  do
     print_brackets `get_details_switch  ${1:$i:1}`
  done
}

tokenize_switch_string(){
  SWITCH=$1
  INFO=`man mkdir | grep -e $SWITCH -A 1 | tail -1`
  print_brackets $INFO
}

tokenize_switch(){
  if [ ${1:0:2} == "--" ]; then
    tokenize_switch_string $1
  else
    tokenize_switch_char $1
  fi
}

token_type(){
  case $1 in
     '|') PIPES=$((PIPES + 1))
          echo "on previous output"
      ;;
    -*) tokenize_switch $1
      ;;
     *) #echo "PIPES" $PIPES "COMMAND_STACK" ${#COMMAND_STACK[@]}
        if [ ${PIPES} = ${#COMMAND_STACK[@]} ]; then
          COMMAND_STACK+=( $1 )        
          #echo "command"
          echo `get_details_command $1`
        else
          echo "on input params : " `print_brackets $1`
        fi
      ;;
  esac
}

COMMAND_STACK=()
PIPES=0
tokenize $PARAMS
#echo $PIPES
#echo ${COMMAND_STACK[@]}
