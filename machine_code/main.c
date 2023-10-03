int sum(int a, int b) {
	return a + b;
}

int fib(int n) {
	if(n == 0 || n == 1) return 1;
	return fib(n - 1) + fib(n - 2);
}

int main(char **args, int nargs) {
	int a;
	int b;
	int *ans = (int *)0x00000100;
	a = 3;
	b = 1;
	int c = sum(a, b);
	*ans = fib(c);
	while(1);
	return 0;
}
