#!/bin/bash
echo  -e "\033[46mCompilando tp0\033[0m" 
make
echo ' '

echo  -e "\033[46mComienzo del test de base64\033[0m" 
# Busco la carpeta
if [ -d tests ] ; then
    echo "Test encontrados"  > /dev/null
else
﻿   echo  -e "\033[31mNo se encontro la carpeta tests\033[0m" 1>&2
﻿   exit 1
fi

#busco el tp y verificador
ls ./tp0 > /dev/null 2>&1
if [ $? -ne 0 ]; then
    echo  -e "\033[31mNo se encontro el archivo tp0 en la carpeta actual\033[0m" 1>&2
#    exit 1
fi
resultado=0

#pruebo los metodos de entrada
echo -e "\033[1mComienza test entrada archivo\033[0m"

./tp0  -e -i ./tests/test_entrada.test > ./archivo_test.temp
diff ./tests/test_entrada.result ./archivo_test.temp > /dev/null
if [ $? -eq 0 ]
then
   echo  -e "\033[31mfin del test entrada archivo\033[0m"  > /dev/null
   echo -e "\033[32mTodas las pruebas han pasado satisfactoriamente\033[0m"
   resultado=0||$resultado
else
   echo  -e "\033[31mfin del test entrada archivo\033[0m"
   echo -e "\033[31mSe han encontrado errores en la entrada de los datos por archivo\033[0m" 1>&2
   resultado=0||$resultado
fi
echo ' '

echo -e "\033[1mComienza test entrada std\033[0m"

./tp0  < ./tests/test_entrada.test > ./archivo_test.temp
diff ./tests/test_entrada.result ./archivo_test.temp > /dev/null
if [ $? -eq 0 ]
then
   echo  -e "\033[31mfin del test entrada std\033[0m"  > /dev/null
   echo -e "\033[32mTodas las pruebas han pasado satisfactoriamente\033[0m"
   resultado=0||$resultado
else
   echo  -e "\033[31mfin del test entrada std\033[0m"
   echo -e "\033[31mSe han encontrado errores en la entrada de los datos por archivo\033[0m" 1>&2
   resultado=0||$resultado
fi
echo ' '


#pruebo los metodos de salida
echo -e "\033[1mComienza test salida std\033[0m"

./tp0  < ./tests/test_entrada.test > ./archivo_test.temp
diff ./tests/test_entrada.result ./archivo_test.temp > /dev/null
if [ $? -eq 0 ]
then
   echo  -e "\033[31mfin del test entrada archivo\033[0m"  > /dev/null
   echo -e "\033[32mTodas las pruebas han pasado satisfactoriamente\033[0m"
   resultado=0||$resultado
else
   echo  -e "\033[31mfin del test entrada archivo\033[0m"
   echo -e "\033[31mSe han encontrado errores en la entrada de los datos por archivo\033[0m" 1>&2
   resultado=0||$resultado
fi
echo ' '

echo -e "\033[1mComienza test salida archivo\033[0m"

./tp0  < ./tests/test_entrada.test  -o ./archivo_test.temp
diff ./tests/test_entrada.result ./archivo_test.temp > /dev/null
if [ $? -eq 0 ]
then
   echo  -e "\033[31mfin del test entrada std\033[0m"  > /dev/null
   echo -e "\033[32mTodas las pruebas han pasado satisfactoriamente\033[0m"
   resultado=0||$resultado
else
   echo  -e "\033[31mfin del test entrada std\033[0m"
   echo -e "\033[31mSe han encontrado errores en la entrada de los datos por archivo\033[0m" 1>&2
   resultado=0||$resultado
fi
echo ' '


rm ./archivo_test.temp

totales=`ls ./tests/*.test  | wc -l`
correctos=0
incorrectos=0

# Muestro la cantidad de test a realizar
echo -e "\033[1mCantidad de archivos a probar\033[0m" "\033[32m$totales\033[0m"

echo -e "\033[1mComienza test encode\033[0m"

#Realizo los test para encode
for file in ./tests/*.test ; do
    ./tp0  < "$file" > ./archivo_test.temp
    base64 -w0  "$file" > ./archivo_correcto.temp
    diff ./archivo_correcto.temp ./archivo_test.temp > /dev/null
    if [ $? -eq 0 ]  ; then
        echo $file verificado correctamente > /dev/null
        correctos=`expr $correctos + 1`
    else
       echo -e "\033[31m$file error al verificar\033[0m" 1>&2
       echo -e "\033[1mEl resultado del encode\033[0m"
       diff ./archivo_correcto.temp ./archivo_test.temp
       echo " "
       incorrectos=`expr $incorrectos + 1`
   fi
done

rm ./archivo_test.temp
rm ./archivo_correcto.temp
if [ $incorrectos -eq 0 ] && [ `expr $correctos + $incorrectos` -eq $totales ] 
then
   echo  -e "\033[31mfin del test encode\033[0m"  > /dev/null
   echo -e "\033[32mTodas las pruebas han pasado satisfactoriamente\033[0m"
   resultado=0||$resultado
else
   echo  -e "\033[31mfin del test encode\033[0m"
   if [ $incorrectos -eq 0 ]
   then
       echo -e "\033[31mNo se han probado todos los archivos debido a un error\033[0m" 1>&2
   else
       echo -e "\033[31mSe han encontrado errores en el encode en \033[0m\033[1m$incorrectos\033[0m\033[31m tests\033[0m" 1>&2
   fi
   resultado=1||$resultado
fi
echo " "
echo " "



echo -e "\033[1mComienza test decode\033[0m"

totales=`ls ./tests/*.test  | wc -l`
correctos=0
incorrectos=0

#Realizo los test para decode
for file in ./tests/*.test ; do
   ./tp0 < "$file" > ./archivo_encodeado.temp
   base64 -w0 -d ./archivo_encodeado.temp > ./archivo_test.temp
   diff "$file" ./archivo_test.temp > /dev/null
   if [ $? -eq 0 ]  ; then
       echo $file verificado correctamente > /dev/null
       correctos=`expr $correctos + 1`
   else
       echo -e "\033[31m$file error al verificar\033[0m" 1>&2
       echo -e "\033[1mEl resultado fue\033[0m"
       diff "$file" ./archivo_test.temp
       echo " "
       incorrectos=`expr $incorrectos + 1`
   fi
done

rm ./archivo_test.temp
rm ./archivo_encodeado.temp
if [ $incorrectos -eq 0 ] && [ `expr $correctos + $incorrectos` -eq $totales ] 
then
   echo  -e "\033[1mfin del test\033[0m"  > /dev/null
   echo -e "\033[32mTodas las pruebas han pasado satisfactoriamente\033[0m"
   resultado=0||$resultado
else
   echo  -e "\033[1mfin del test \033[0m"
   if [ $incorrectos -eq 0 ]
   then
       echo -e "\033[31mNo se han probado todos los archivos debido a un error\033[0m" 1>&2
   else
       echo -e "\033[31mSe han encontrado errores en \033[0m\033[1m$incorrectos\033[0m\033[31m tests\033[0m" 1>&2
   fi
   resultado=1
fi

exit $resultado

