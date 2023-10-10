int sum(int a, int b) {
	return a + b;
}
int gcd(int a, int b) {
	if(b==0) return a;
	return gcd(b,a%b);
}

int fib(int n) {
	if(n == 0 || n == 1) return 1;
	return fib(n - 1) + fib(n - 2);
}

int main(char **args, int nargs) {
	int a;
	int b;
	int *ans1 = (int *)0x00000100;
	int *ans2 = (int *)0x00000104;
	a = 3;
	b = 1;
	int c = sum(a, b);
	c = (-c) * (-c);
	c = c / 4;
	*ans1 = fib(c);
	*ans2 = gcd(60, 48);
	while(1);
	return 0;
}
