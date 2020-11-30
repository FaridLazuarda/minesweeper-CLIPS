from clipspy import ClipsMinesweeper
from gui import *

class Minesweeper():
    def __init__(self, size, num_bombs):
        self.size = size
        self.board_state = [[0 for i in range(size)] for j in range(size)]
        self.count_bombs = num_bombs
        self.bomb_coords = []
        self.init_board()
        self.input_bombs()
        self.init_board_val()

    def init_board(self):
        for i in range(self.size):
            for j in range(self.size):
                self.board_state[i][j] = 0

    def init_board_val(self):
        self.board_val1 = [[0 for i in range(self.size)] for j in range(self.size)]
        self.board_val2 = [[0 for i in range(self.size)] for j in range(self.size)]

        for col in range(self.size):
            for row in range(self.size):
                if(self.board_state[col][row] != -1):
                    numMines = 0
                    cols = [col]
                    rows = [row]

                    if col-1 >= 0:
                        cols.append(col-1)
                    if col+1 < self.size:
                        cols.append(col+1)

                    if row-1 >= 0:
                        rows.append(row-1)
                    if row+1 < self.size:
                        rows.append(row+1)
                    for x in cols:
                        for y in rows:
                            if self.board_state[x][y] == -1:
                                numMines = numMines + 1
                    self.board_state[col][row] = numMines

    def input_bombs(self):
        for i in range(self.count_bombs):
            x,y = input().strip().split(',')
            x = int(x)
            y = int(y)
            self.bomb_coords.append([x,y])
        
        for i,j in self.bomb_coords:
            self.board_state[i][j] = -1

    def print_board(self):
        for row in self.board_state:
            for el in row:
                print(el, end=" ")
            print()

if __name__ == "__main__":
    size = int(input('Input size board : '))
    num_bombs = int(input('Input number of bombs : '))
    ms = Minesweeper(size, num_bombs)
    ms.print_board()

    clips = ClipsMinesweeper()
    clips.environment.reset()
    clips.load_board(size, num_bombs)
    clips.load_square(ms.board_state)
    # clips.print_facts()

    
    # clips.environment.run()
    # clips.print_facts()
    # while True :
    #     clips.environment.run(limit=1)
    #     a = input('next ? ')
    #     i=0
    #     for fact in clips.environment.facts():
    #         template_square = clips.environment.find_template('square')
    #         print(i, fact)
    #         if fact.template == template_square: 
    #             print(fact['x'], ' ', fact['y'])
    #         i += 1

    app = QApplication([])
    window = Board(size, num_bombs, ms.bomb_coords, clips)
    app.exec_()