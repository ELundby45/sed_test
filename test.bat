
:: Before running test.bat, create and activate the test env. 
: conda create -n sed_test python=3.11 m2-diffutils m2-sed -y
: conda activate sed_test


set "PY_VER=3.11"
set "CONDA_PY=311"

::::::::::::::

for /f "tokens=2" %%a in ('python --version 2^>^&1') do set PY_VERSION_FULL=%%a

:: Replace Python312 or python312 with ie Python311 or python311
sed "s/\([Pp]ython\)312/\1%CONDA_PY%/g" build/CMakeCache.txt.orig > build/CMakeCache.txt

:: Replace version string v3.12.8() with ie v3.11.11()
sed -i.bak -E "s/v3\.12\.[0-9]+/v%PY_VERSION_FULL%/g" build/CMakeCache.txt

:: Replace interpreter properties Python;3;12;8;64 with ie Python;3;11;11;64
sed -i.bak -E "s/Python;3;12;[0-9]+;64/Python;%PY_VERSION_FULL:.=;%;64/g" build/CMakeCache.txt

:: Replace cp312-win_amd64 with ie cp311-win_amd64
sed -i.bak "s/cp312/cp%CONDA_PY%/g" build/CMakeCache.txt

::::::::::::::

diff build/CMakeCache.txt build/expected.txt

