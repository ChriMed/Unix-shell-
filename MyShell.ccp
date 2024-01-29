#include <cstdlib> // standard library
#include <cstring> //
#include <iostream>
#include <stdio.h>  // Standard input and Output
#include <string.h> // Strings
#include <sys/wait.h>
#include <unistd.h> // Unix commands
#define TOKEN_SIZE 100
#define MAX_SIZE 10
using namespace std;

class Hist {
private:
  char data[MAX_SIZE][TOKEN_SIZE];
  int count;

public:
  Hist();
  void add(char[]);
  void get(int, char[]);
  void display();
};

Hist::Hist() {
  count = 0;
  for (int i = 0; i < MAX_SIZE; i++) {
    strcpy(data[i], "");
  }
}
void Hist::add(char x[]) {
  if (count < MAX_SIZE) {
    strcpy(data[count], x);
    count++;
  } else {
    for (int i = 0; i < MAX_SIZE - 1; i++)
      strcpy(data[i], data[i + 1]);
    strcpy(data[MAX_SIZE - 1], x);
  }
  return;
}

void Hist::get(int x, char y[]) {
  if (x <= count)
    strcpy(y, data[x - 1]);
  else
    strcpy(y, "");
}

void Hist::display() {
  for (int i = 0; i < MAX_SIZE; i++) {
    cout << i << ": " << data[i] << " ";
  }
  cout << endl;
  return;
}
int main() {
  Hist Command;
  char line[TOKEN_SIZE];
  char x[MAX_SIZE];
  char *argv[MAX_SIZE];
  int status;
  int process_id;

  while (1) {
    cout << "Shell: ";
    cin.getline(line, TOKEN_SIZE);
    int i = 0;
    argv[i] = strtok(line, " \n"); // Extract argv[0] command

    while (argv[i] != NULL) // We keep extracting
    {
      i++;
      argv[i] = strtok(NULL, " \n");
    }
    argv[i] = NULL; // last one must be NULL

    Command.add(strtok(line, " \n")); // Extract argv[0] command

    if (strcmp(argv[0], "cd") == 0) {
      if (chdir(argv[1]) != 0) {
        perror("chdir failed");
      }
      continue;
    }else if (strcmp(argv[0], "exit") == 0) {
      exit(0);
    } else if (strcmp(argv[0], "hist-") == 0) {
      string input;
      cout << "Enter index:";
      getline(cin, input);
      int num = stoi(input);
      Command.get(num, x);
      cout << num - 1 << ":" << x << endl;
      continue;
    } else if (strcmp(argv[0], "hist") == 0) {
      Command.display();
      continue;
    }

    // create a child process and execute the command
    process_id = fork();
    if (process_id == 0) {
      // child process
      execvp(argv[0], argv);
      perror("execvp failed");
    } else {
      // parent process
      wait(&status);
    }
  }
  return 0;
}
