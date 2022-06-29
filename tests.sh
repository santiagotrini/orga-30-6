#!/bin/bash

# colores
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

# contador
tests_passed=0

# funciones
test_output() {
  output=$($1)
  expected=$2
  if [[ "$output" == "$expected" ]]
  then
    echo -e "[  ${GREEN}OK${NC}  ]: $1 → $2 ${GREEN}✓${NC}"
    tests_passed=$((tests_passed + 1))
  else
    echo -e "[ ${RED}Fail${NC} ]: Esperaba '$expected' pero se obtuvo '$output' ${RED}✗${NC}"
  fi
}
contains() {
  (grep "$1" $2) > /dev/null
  exit_code=$?
  if [[ "$exit_code" -eq 0 ]]
  then
    echo -e "[  ${GREEN}OK${NC}  ]: $2 contiene $1 ${GREEN}✓${NC}"
    tests_passed=$((tests_passed + 1))
  else
    echo -e "[ ${RED}Fail${NC} ]: $2 no contiene $1 ${RED}✗${NC}"
  fi
}
test_output_ml() {
  output=$(echo $1 | $2)
  expected=$3
  if [[ "$output" == "$expected" ]]
  then
    echo -e "[  ${GREEN}OK${NC}  ]: echo $1 | spim -q -f 1_matrix.s ${GREEN}✓${NC}"
    tests_passed=$((tests_passed + 1))
  else
    echo -e "[ ${RED}Fail${NC} ]: $1 ${RED}✗${NC}"
  fi
}

# 1_matrix
test_output_ml "1" "spim -q -f 1_matrix.s" "1"
test_output_ml "2" "spim -q -f 1_matrix.s" "10
01"
test_output_ml "3" "spim -q -f 1_matrix.s" "100
010
001"
test_output_ml "4" "spim -q -f 1_matrix.s" "1000
0100
0010
0001"
test_output_ml "5" "spim -q -f 1_matrix.s" "10000
01000
00100
00010
00001"
test_output_ml "6" "spim -q -f 1_matrix.s" "100000
010000
001000
000100
000010
000001"
test_output_ml "7" "spim -q -f 1_matrix.s" "1000000
0100000
0010000
0001000
0000100
0000010
0000001"
test_output_ml "8" "spim -q -f 1_matrix.s" "10000000
01000000
00100000
00010000
00001000
00000100
00000010
00000001"
test_output_ml "9" "spim -q -f 1_matrix.s" "100000000
010000000
001000000
000100000
000010000
000001000
000000100
000000010
000000001"
contains "main:" "1_matrix.s"
matrix_tests=$tests_passed
echo
# 2_lower
test_output "spim -q -f 2_lower.s AyAlA" "ayala"
test_output "spim -q -f 2_lower.s HOLA" "hola"
test_output "spim -q -f 2_lower.s hola" "hola"
test_output "spim -q -f 2_lower.s 1234?ABC" "1234?abc"
test_output "spim -q -f 2_lower.s FlOggEr" "flogger"
test_output "spim -q -f 2_lower.s AbCdEfG" "abcdefg"
test_output "spim -q -f 2_lower.s 12345" "12345"
test_output "spim -q -f 2_lower.s Juan" "juan"
test_output "spim -q -f 2_lower.s 45aSd" "45asd"
test_output "spim -q -f 2_lower.s SnakeCase" "snakecase"
test_output "spim -q -f 2_lower.s camelCase" "camelcase"
test_output "spim -q -f 2_lower.s Pascal_case" "pascal_case"
test_output "spim -q -f 2_lower.s ABELLO" "abello"
test_output "spim -q -f 2_lower.s 67^5HHll" "67^5hhll"
test_output "spim -q -f 2_lower.s XYZ=123" "xyz=123"
test_output "spim -q -f 2_lower.s niciIIIIItoooOOO" "niciiiiiitoooooo"
contains "main:" "2_lower.s"
contains "lower:" "2_lower.s"
contains "jal lower" "2_lower.s"
contains "addi \$sp, \$sp" "2_lower.s"
lower_tests=$(( $tests_passed - $matrix_tests ))
echo
echo "--------------  Resultado  --------------"
if [[ $tests_passed -eq 30 ]]
then
  echo -e "Todos los tests pasaron ${GREEN}✓${NC}"
  echo "Nota: 10.00"
else
  echo -e "1_matrix: $matrix_tests/10 ${GREEN}✓${NC}"
  echo -e "2_lower: $lower_tests/20 ${GREEN}✓${NC}"
  echo
  echo "Total: $tests_passed/30 tests OK."
  echo "Nota: " $(bc -l <<< "scale=2; (10/30) * $tests_passed")
fi

exit 0
