#include "StateValidityCheckerPCS.h"

#include <stdio.h>
#include <stdlib.h>
#include <fstream>

int main() {

	int Seed = time(NULL);
	srand( Seed );
	cout << "Seed in testing: " << Seed << endl;

	// APC
	StateValidityChecker svc;

	State q = svc.sample_q();

	svc.printVector(q);
	cout << svc.collision_state(q) << endl;

	svc.two_robots::log_q(q);
}