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
    token_type $i  
  done
}

get_details_command(){
  apropos $1 | head -1 | tr -s ' ' | cut -d '-' -f2

}

get_details_switch(){

  SWITCH=-$1
  man mkdir | grep -e $SWITCH -A 1 | tail -1
}


tokenize_switch_char(){
  for i in ${1:1}
  do
    print_brackets `get_details_switch $i`
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
    -*) tokenize_switch $1
      ;;
     *) echo `get_details_command $1`
      ;;
  esac
}

tokenize $PARAMS
