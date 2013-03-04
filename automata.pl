:- module(automata, [test_automata/2, test_dfa/2]).

recognize(Machine,Node,[]) :-
	call(Machine, DefList),
	member(accept(Node), DefList).

recognize(Machine,Node,[Head|Tail]) :-
	call(Machine, DefList),
	member(trans(Node, Next, Head), DefList),
	recognize(Machine,Next,Tail).
	
run_recognizer(Machine,Input) :-
	call(Machine, DefList),
	member(start(Node), DefList),
	recognize(Machine, Node, Input).

test_automata(Machine, Inputs) :- 
	forall( member([Input, Expected], Inputs),
		test_single_input(Machine, Input, Expected)).

test_single_input(Machine, Input, Expected) :-
	 accepted_desc(Expected, Desc),
	 ( (Expected ->
		run_recognizer(Machine, Input);
		\+ run_recognizer(Machine, Input)) ->
			write_success(Input, Desc);
			write_failure(Input, Desc)).
test_dfa(Machine, Expected) :-
	is_dfa_desc(Expected, Desc),
	( ( Expected -> is_dfa(Machine);
		\+ is_dfa(Machine) ) ->
		write_success(Machine, Desc);
		write_failure(Machine, Desc) ).

write_success(Input, Desc) :-
	 write_green, writef('✔ %q - %w\n', [Input, Desc]), write_normal.
write_failure(Input, Desc) :-
	write_red, writef('✘ %q - expected: %w\n', [Input, Desc]), write_normal.

write_green :- writef('\033[32m').
write_red :- writef('\033[31m').
write_normal :- writef('\033[0m').

accepted_desc(true, accepted).
accepted_desc(false, 'not accepted').
is_dfa_desc(true, 'DFA').
is_dfa_desc(false, 'NFA').

is_dfa(Machine) :-
	call(Machine, DefList),
	\+ ( member(trans(N1, N2, Sym), DefList),
		member(trans(N1, N3, Sym), DefList),
		N2 \= N3 ).
is_nfa(Machine) :- \+ is_dfa(Machine).


% vim: ft=prolog
