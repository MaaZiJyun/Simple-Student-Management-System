#!/bin/bash

# This is the project of Course SKR3307 Shell Programming
# Group members are:
# 1. Wen Yu 199657
# 2. Wang Yida 201406
# 3. Ma Zhiyuan 201464
# 4. ZHOU LINGPEI(201357)

# ----------------------------------------------PROGRAMMING SECTION------------------------------------------------------

# Color variable: additional attributes

NC='\033[0m'
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'

# /////

# title_printing: print the title of the project

function bigTitle(){
    echo -e "${GREEN}
   ______          __         __
  / __/ /___ _____/ /__ ___  / /_
 _\ \/ __/ // / _  / -_) _ \/ __/
/___/\__/\_,_/\_,_/\__/_//_/\__/                 __
  /  |/  /__ ____  ___ ____ ____ __ _  ___ ___  / /_
 / /|_/ / _ \`/ _ \/ _ \`/ _ \`/ -_)  ' \/ -_) _ \/ __/
/_/__/_/\_,_/_//_/\_,_/\_, /\__/_/_/_/\__/_//_/\__/
  / __/_ _____ / /____/___/
 _\ \/ // (_-</ __/ -_)  ' \
/___/\_, /___/\__/\__/_/_/_/
    /___/
    "
}

# main function: the entrance of the system
function main(){
    clear
    while :
    do
        echo ""
        bigTitle
        echo ""
        echo "1. FIND STUDENT"
        echo "2. INSERT STUDENT"
        echo "3. REMOVE STUDENT"
        echo "4. SHOW LIST"
        echo "5. EDIT LIST"
        echo "6: INFORMATION"
        echo "0: EXIT PROGRAM"
        echo ""
        
        echo -e -n "Please Enter Your Choice: ${NC}"
        read choice
        
        case $choice in
            1 ) findStudent;
            ;;
            2 ) insertStudent; clear
            ;;
            3 ) deleteStudent; clear
            ;;
            4 ) showList;
            ;;
            5 ) editList; clear
            ;;
            6 ) showInfo;
            ;;
            7 ) editList2; clear
            ;;
            0 ) exitProgram; clear
            ;;
            * ) echo -e "${RED}Invalid Choice !${NC}"
                sleep 1
                clear
            ;;
        esac
    done
}

# Edit with command
function editList(){
    clear
    echo -e "${BLUE}\n\nThe information is: \n${NC}"
    cat ./studentList.txt
    echo -e "${BLUE}\nInput the NAME of the student you want to edit: ${YELLOW}"
    read NAME
    if [ "$NAME" = "" ]; then
        echo -e "${RED}Invalid Input${NC}"
    else
        GET=`grep "$NAME" ./studentList.txt`
        if [ -n "$GET" ]; then
            grep -v "$NAME" ./studentList.txt > ./temp
            mv ./temp ./studentList.txt
            rm -f ./temp
            echo -e "${Blue}Enter the new record${NC}"
            insertStudent
        else
            echo -e "${RED}Student${YELLOW} ${NAME} ${RED}was not found ${NC}"
        fi
    fi
    echo -e "\n\n\n"
    read -n 1 -s -r -p "Press any key to continue"
    clear
}

# Screen Help Function
function showInfo() {
    clear
    echo "This is the project of Course SKR3307 Shell Programming
Group members are:
1. Wen Yu 199657
2. Wang Yida 201406
3. Ma Zhiyuan 201464
    4. Zhou Lingpei 201357"
}

# Exit
function exitProgram() {
    clear
    exit
}

# calculation of the grades of the students
function calculation(){
    # $result = `expr $1 + $2`
    #   result=$(($1 + $2))
    #   echo $result
    let total=$1+$2+$3+$4+$5
    let per=(total/5)
    let grade
    if [ "$per" -ge 80 ];
    then
        grade="A"
    elif [ "$per" -ge 70 -a $per -lt 80 ];
    then
        grade="B"
    elif [ "$per" -ge 60 -a $per -lt 70 ];
    then
        grade="C"
    elif [ "$per" -ge 50 -a $per -lt 60 ];
    then
        grade="D"
    elif [ "$per" -ge 40 -a $per -lt 50 ];
    then
        grade="E"
    else
        grade="F"
    fi
}

# insertStudent: add new student info to the list
function insertStudent(){
    clear
    printf "${BLUE}Enter NAME: ${NC}"
    read name
    printf "${BLUE}Enter METRIC: ${NC}"
    read metric
    printf "${BLUE}Enter SCORE 1: ${NC}"
    read s1
    printf "${BLUE}Enter SCORE 2: ${NC}"
    read s2
    printf "${BLUE}Enter SCORE 3: ${NC}"
    read s3
    printf "${BLUE}Enter SCORE 4: ${NC}"
    read s4
    printf "${BLUE}Enter SCORE 5: ${NC}"
    read s5
    
    calculation $s1 $s2 $s3 $s4 $s5
    GET=`grep "$metric" ./studentList.txt | cut -d '|' -f 2`
    # printf $GET
    if [ "$GET" = "$metric" ]; then
        echo -e "${RED}Metric repeatation, Please try another one${NC}\n"
    else
        record=`printf "%s|%s|%s|%s|%s|%s|%s|%s|%s\n" ${name} ${metric} ${s1} ${s2} ${s3} ${s4} ${s5} ${per} ${grade}`
        echo "$record" >> ./studentList.txt
        
        sort -o ./studentList.txt ./studentList.txt
        echo -e "${GREEN}inserted successfully${NC}\n"
    fi

    read -n 1 -s -r -p "Press any key to continue"
}

# Delete a person in student list
function deleteStudent() {
    clear
    echo -e "${BLUE}Please input the NAME >>> ${NC}"
    read NAME
    
    if [ ! -f ./studentList.txt ]; then
        echo -e "${YELLOW}List is empty, Please add it first. ${NC}"
    else
        if [ "$NAME" != "" ]; then
            cp studentList.txt studentList.bak
            
            grep "$NAME" ./studentList.bak > /dev/null
            # /dev/null is the black hole, it will lose all the data inputted
            if [ $? != 0 ]; then
                echo -e "${RED}This person not exist.${NC}"
            else
                grep -v "$NAME" ./studentList.bak > studentList.txt
                echo -e "${GREEN}Already DELETE it successfully${NC}"
            fi
            rm -f studentList.bak
        else
            echo -e "${RED}Invalid Input${NC}"
        fi
    fi
    sleep 1
}

# Display the student list
function showList() {
    clear
    if [ ! -f ./studentList.txt ]; then
        echo -e "${RED}List is empty, Please add it first. ${NC}"
        sleep 2
        clear
        return 0
    fi
    echo -e "${BLUE}\n\nThe information is: \n${NC}"
    printf "%-10s%-20s%-10s%-10s%-10s%-10s%-10s%-10s%-20s%-10s\n" "Index" "Name" "Metric" "Score1" "Score2" "Score3" "Score4" "Score5" "Percentage" "Grade"
    echo "----------------------------------------------------------------------------------------------------------------------"
    i=1
    while read line
    do
        name=`echo "$line" | cut -d '|' -f 1`
        metric=`echo "$line" | cut -d '|' -f 2`
        s1=`echo "$line" | cut -d '|' -f 3`
        s2=`echo "$line" | cut -d '|' -f 4`
        s3=`echo "$line" | cut -d '|' -f 5`
        s4=`echo "$line" | cut -d '|' -f 6`
        s5=`echo "$line" | cut -d '|' -f 7`
        per=`echo "$line" | cut -d '|' -f 8`
        grade=`echo "$line" | cut -d '|' -f 9`
        printf "%-10s%-20s%-10s%-10s%-10s%-10s%-10s%-10s%-20s%-10s\n" ${i} ${name} ${metric} ${s1} ${s2} ${s3} ${s4} ${s5} ${per} ${grade}
        i=`expr $i + 1`
    done < ./studentList.txt
    echo -e "\n\n\n"
    read -n 1 -s -r -p "Press any key to continue"
    clear
}

# find function
function findStudent(){
    clear
    echo -e "${BLUE}Please Enter NAME >>> ${NC}"
    read NAME
    # If there is no studentList file
    if [ ! -f ./studentList.txt ]; then
        echo -e "${RED}List is empty, Please add it first! ${NC}"
        sleep 2
        clear
        return
    fi
    # When no name is entered.
    if [ -z "$NAME" ]; then
        # -z means when $NAME.length = 0, it returns true
        echo -e "${RED}You didn't enter a name!"
        echo -e "${RED}Invalid Input${NC}"
        
    else
        grep "$NAME" ./studentList.txt > ./temp
        GET=`grep "$NAME" ./studentList.txt`
        if [ -n "$GET" ]; then
            echo -e "${BLUE}\n\nThe information is: \n${NC}"
            awk '{print NR " - " $0}' ./temp
        else
            echo -e "${RED}Student${YELLOW} ${NAME} ${RED}was not found ${NC}"
        fi
        rm -f ./temp
    fi
    echo -e "\n\n\n"
    read -n 1 -s -r -p "Press any key to continue"
    clear   
}

# Run
main
