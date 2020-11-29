

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
                            if self.board_state[y][x] == -1:
                                numMines = numMines + 1
                    self.board_state[row][col] = numMines

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
    ms = Minesweeper(10,3)
    ms.print_board()
    