--load_data

pokemon_data = LOAD '/home/acadgild/pig/pokemon_usecase/Pokemon.csv' USING PigStorage(',') AS(Sno:int,Name:chararray,Type1:chararray,Type2:chararray,Total:int,HP:int,Attack:int,Defense:int,SpAtk:int,SpDef:int,Speed:int);

--question 1 : Find the list of players that have been selected in the qualifying round (DEFENCE>55).

selected_list = FILTER pokemon_data BY Defense > 55;
STORE selected_list INTO '/home/acadgild/pig/output/pokemon_usecase/problem_1';

--question 2 : State the number of players taking part in the competition after getting selected in the qualifying round.

gourp_selected_list = Group selected_list All;
count_selected_list = foreach gourp_selected_list GENERATE COUNT(selected_list);
STORE count_selected_list INTO '/home/acadgild/pig/output/pokemon_usecase/problem_2';

--Question 3: Using random() generate random numbers for each Pokémon on the selected list.This will create a list1 containing Pokémon to be considered for fighting each other. 

random_include1 = foreach selected_list GENERATE RANDOM(),Name,Type1,Type2,Total,HP,Attack,Defense,SpAtk,SpDef,Speed;
STORE random_include1 INTO '/home/acadgild/pig/output/pokemon_usecase/problem_3';

--Question 4: Using random() generate random numbers for each Pokémon on the selected list.This will create a list2 containing Pokémon to be considered for fighting each other. 

random_include2 = foreach selected_list GENERATE RANDOM(),Name,Type1,Type2,Total,HP,Attack,Defense,SpAtk,SpDef,Speed;
STORE random_include2 INTO '/home/acadgild/pig/output/pokemon_usecase/problem_4';

--Question 5: Arrange the new list in a descending order according to a column randomly.This will give us consequently a layer arranged to pick the random list which 1st player will choose. 

random1_desending = ORDER random_include1 BY $0 DESC;
STORE random1_desending INTO '/home/acadgild/pig/output/pokemon_usecase/problem_5';

--Question 6: Arrange the new list in a descending order according to a column randomly.This will give us consequently a layer arranged to pick the random list which 2nd player will choose. 

random2_desending = ORDER random_include2 BY $0 DESC;
STORE random2_desending INTO '/home/acadgild/pig/output/pokemon_usecase/problem_6';

--Question 7: From the two different descending lists of random Pokémons, select the top 5 Pokémons for 2 different players. select top 5 from list 1 

limit_data_random1_desending = LIMIT random1_desending 5 ;
STORE limit_data_random1_desending INTO '/home/acadgild/pig/output/pokemon_usecase/problem_7';

--Question 8: From the two different descending lists of random Pokémons, select the top 5 Pokémons for 2 different players. select top 5 from list 2 

limit_data_random2_desending = LIMIT random2_desending 5 ;
STORE limit_data_random2_desending INTO '/home/acadgild/pig/output/pokemon_usecase/problem_8';

--Question 9: Store the data on a local drive to announce for the final match. By the name player1,player2 (only show the NAME and HP).

filter_only_name1 = foreach limit_data_random1_desending Generate ($1,HP);
STORE filter_only_name1 INTO '/home/acadgild/pig/output/pokemon_usecase/problem_9/player1';

filter_only_name2 = foreach limit_data_random2_desending Generate ($1,HP);
STORE filter_only_name2 INTO '/home/acadgild/pig/output/pokemon_usecase/problem_9/player2';
















