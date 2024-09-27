.PHONY: filelist comp sim clean 


COMPILE_TOOL    := vcs
COMPILE_OPTIONS := -l ./build/log/comp.log \

SIM_OPTION      := 


SIM_FILES       := -f ./build/filelist.f
TB_FILES        := 

DEFINE_OPTIONS  := 

filelist :
	find ./src -name '*v' > ./build/filelist.f

comp : 
	mkdir build; mkdir ./build/comp; ./build/sim \	
	${COMPILE_TOOL} ${COMPILE_OPTION} ${SIM_FILES} ${TB_FILES} ${DEFINE_OPTION}

sim  : comp
	./build/simv ${SIM_OPTION} 

clean :
	rm -rf ./build

