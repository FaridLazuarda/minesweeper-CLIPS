from clipspy import ClipsMinesweeper
from gui import *

class Minesweeper():
    def __init__(self, size, num_bombs, coords_bombs):
        self.size = size
        self.board_state = [[0 for i in range(size)] for j in range(size)]
        self.count_bombs = num_bombs
        self.bomb_coords = coords_bombs
        self.init_board()
        self.mark_bombs()
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

    def mark_bombs(self):
        # for i in range(self.count_bombs):
        #     x,y = input().strip().split(',')
        #     x = int(x)
        #     y = int(y)
        #     self.bomb_coords.append([x,y])
        
        for (i,j) in self.bomb_coords:
            self.board_state[i][j] = -1

    def print_board(self):
        for i in range(len(self.board_state)):
            for j in range(len(self.board_state[i])):
                print(self.board_state[j][i], end=" ")
            print()

if __name__ == "__main__":
    _filename = input('Input your game config file: ')
    _file = open(_filename, 'r')
    arr_bombs = []
    i = 0
    for f in _file:
        if i == 0:
            boardsize = int(f)
        elif i == 1:
            n_bombs = int(f)
        else:
            arr_bombs.append(tuple(f.split(',')))
        i += 1

    for i in range (len(arr_bombs)):
        arr_bombs[i] = (int(arr_bombs[i][0]), int(arr_bombs[i][1]))

    ms = Minesweeper(boardsize, n_bombs, arr_bombs)
    ms.print_board()

    clips = ClipsMinesweeper()
    clips.environment.reset()
    clips.load_board(boardsize, n_bombs)
    clips.load_square(ms.board_state)

    app = QApplication([])
    window = Board(boardsize, n_bombs, ms.bomb_coords, clips)
    app.exec_()
    
    # size = int(input('Input size board : '))
    # num_bombs = int(input('Input number of bombs : '))
    
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