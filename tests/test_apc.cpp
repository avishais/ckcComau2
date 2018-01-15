#include "apc_class.h"

#include <stdio.h>
#include <stdlib.h>
#include <fstream>

#include "../proj_classes/def.h"

double fRand(double fMin, double fMax)
{
	double f = (double)rand() / RAND_MAX;
	return fMin + f * (fMax - fMin);
}

double dist(State p1, State p2) {
	double sum = 0;
	for (int i = 0; i < p1.size(); i++)
		sum += (p1[i]-p2[i])*(p1[i]-p2[i]);

	return sqrt(sum);
}

int main() {

	int Seed = time(NULL);
	srand( Seed );
	cout << "Seed in testing: " << Seed << endl;

	// APC
	two_robots A;

	// State q1(6,0);
	// State q2(6,0);
	// // q = {0.3, -0.5, 0.5, 0, 0.4, 0};
	// q2[0] = 1.5707;
	// A.printVector(q2);

	// A.FKsolve_rob(q2, 2);
	// Matrix T = A.get_FK_solution_T2();
	// A.printMatrix(T);

	// for (int i = 0; i < 8; i++) {
	// 	A.IKsolve_rob(T, 2, i);

	// 	A.printVector(A.get_IK_solution_q2());
	// }

	State q(12);// = {-0.262098, 1.25857, -1.81284, -3.13239, -0.0252604, 1.13626, -1.7244, -1.04968, -0.715249, 1.57762, 2.10969, 2.22163};
	State q1(6), q2(6);
	while (1) {
		// Random active chain
		for (int i = 0; i < 6; i++)
			q1[i] = fRand(-3.14, 3.14);
		// q1 = {-0.15, 0.33, -0.05, 0, 1.2908, -1.7208};
		//A.FKsolve_rob(q1, 1);
		//A.printMatrix(A.get_FK_solution_T1());
		//cin.ignore();

		int ik_sol = rand() % 8;
		

		if (A.calc_specific_IK_solution_R1(q1, ik_sol)) 
			q2 = A.get_IK_solution_q2();
		else
			continue;

			cout << ik_sol << endl;

		for (int i = 0; i < 6; i++) {
			q[i] = q1[i];
			q[i+6] = q2[i];
		}
		//if (A.check_angle_limits(q))
			break;
	}
	A.printVector(q1);	
	
	A.log_q(q);



}

