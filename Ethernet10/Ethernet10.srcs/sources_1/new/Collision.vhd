----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09.12.2022 14:12:37
-- Design Name: 
-- Module Name: Collision - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Collision is
    Port ( CLK      : in    STD_LOGIC;
           RESET    : in    STD_LOGIC; 
           RCVNGP   : in    STD_LOGIC;
           TRNSMTP  : in    STD_LOGIC;
           TSOCOLP  : out   STD_LOGIC;
           RENABP   : out   STD_LOGIC;
           TABORTP  : out   STD_LOGIC);
end Collision;

architecture Behavioral of Collision is

    signal AUX_TSOCOLP :  STD_LOGIC;

begin

    TSOCOLP <= AUX_TSOCOLP;

Main : process

begin

    wait until CLK'Event and CLK='1';
    
    if (RESET = '0' or AUX_TSOCOLP = '1') then
        AUX_TSOCOLP <= '0';
        RENABP      <= '0';
        TABORTP     <= '0';
    
    elsif (RCVNGP = '1' and TRNSMTP = '1') then
        AUX_TSOCOLP <= '1';
        RENABP      <= '1';
        TABORTP     <= '1';
        
    end if;
    
end process;

end Behavioral;
