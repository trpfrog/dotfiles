# Try this if 'brew bundle' doesn't work for mas.

import os

if __name__ == '__main__':
    with open('./Brewfile') as f:
        brew_list = f.readlines()
        for line in brew_list:
            cmd = line.split()
            if len(cmd) == 0 or cmd[0] != 'mas': continue
            appid = cmd[-1]
            os.system('mas install {}'.format(appid))