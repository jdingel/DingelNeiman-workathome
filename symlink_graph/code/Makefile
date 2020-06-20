all: ../output/task_flow.png

../output:
	mkdir $@

../output/graph.txt: graphmaker.sh | ../output
	bash graphmaker.sh
../output/task_flow.png: ../output/graph.txt | ../output
	dot -Grankdir=LR -Tpng ../output/graph.txt -o ../output/task_flow.png