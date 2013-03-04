:- use_module(automata).
:- initialization(run).

example_machine_dfa([
	start(q_0),
	trans(q_0, q_1, 0), % advance state for every consecutive {0}
	trans(q_1, q_2, 0),
	trans(q_2, q_3, 0),

	trans(q_0, q_0, 1), % loop back {1} to q_0
	trans(q_1, q_0, 1), % return to q_0 if only 1-2 {0} have been read followed by a {1}
	trans(q_2, q_0, 1),

	trans(q_3, q_3, 0), % loop back {0, 1} to q_3
	trans(q_3, q_3, 1),
	accept(q_3)
]).

example_machine_nfa([
	start(q_0),
	trans(q_0, q_0, 0), % loop back to q_3 on {0,1}
	trans(q_0, q_0, 1),

	trans(q_0, q_1, 0), % advance state for every consecutive {0}
	trans(q_1, q_2, 0),
	trans(q_2, q_3, 0),

	trans(q_3, q_3, 0), % loop back to q_3 on {0,1}
	trans(q_3, q_3, 1),

	accept(q_3)
]).

test_input([
	[ [0, 0, 0], true ],
	[ [0, 0], false ],
	[ [0, 0, 0, 0], true ],
	[ [0, 0, 0, 1], true ],
	[ [1, 0, 0, 0], true ],
	[ [1, 0, 0, 1], false ],
	[ [0, 1, 0, 0, 1], false ],
	[ [0, 1, 0, 0, 0], true ],
	[ [0, 1, 0, 0, 0, 1], true ],
	[ [0, 1, 0, 0, 0, 0], true ],
	[ [0, 0, 1, 0, 1, 0, 0, 0, 0], true ],
	[ [0, 0, 1, 0, 1, 0, 0, 1, 0], false ],

	[ [0, 0, 1, 0, 1, 0, 0, 1, 0], true ], % purposefully fail
	[ [0, 0, 1, 0, 1, 0, 0, 0, 0], false ] % purposefully fail
]).

run :- test_input(Inputs),
	write('testing DFA\n'),
		test_dfa(example_machine_dfa, true),
		test_automata(example_machine_dfa, Inputs),
	write('=====\n'),
	write('testing NFA\n'),
		test_dfa(example_machine_nfa, false),
		test_automata(example_machine_nfa, Inputs).



% vim: ft=prolog
