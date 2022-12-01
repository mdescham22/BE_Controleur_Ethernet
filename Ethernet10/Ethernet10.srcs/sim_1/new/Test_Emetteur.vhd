----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 16.11.2022 11:27:18
-- Design Name: 
-- Module Name: Test_Emetteur - Behavioral
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

entity TestEmetteur is
end TestEmetteur;

architecture Behavioral of TestEmetteur is

COMPONENT Emetteur
PORT ( CLK : in STD_LOGIC;
       RESET : in STD_LOGIC;
       TABORTP : in STD_LOGIC;
       TAVAILP : in STD_LOGIC;
       TDATAI : in STD_LOGIC_VECTOR (7 downto 0);
       TDATAO : out STD_LOGIC_VECTOR (7 downto 0);
       TDONEP : out STD_LOGIC;
       TFINISHP : in STD_LOGIC;
       TLASTP : in STD_LOGIC;
       TREADDP : out STD_LOGIC;
       TRNSMTP : out STD_LOGIC;
       TSTARTP : out STD_LOGIC);
END COMPONENT;

--Input
signal CLK : std_logic := '0';
signal RESET : std_logic := '0';
signal TABORTP : std_logic := '0';
signal TAVAILP : std_logic := '0';
signal TFINISHP : std_logic := '0';
signal TLASTP : std_logic := '0';
signal TDATAI : std_logic_vector(7 downto 0) := (others => '0');

--Output
signal TDONEP : std_logic;
signal TREADDP : std_logic;
signal TRNSMTP : std_logic;
signal TSTARTP : std_logic;
signal TDATAO : std_logic_vector(7 downto 0);

--Clock period
constant CLK_period : time := 100 ns;

begin

uut : Emetteur PORT MAP (
    CLK      => CLK,
    RESET    => RESET,
    TABORTP  => TABORTP,
    TAVAILP  => TAVAILP,
    TFINISHP => TFINISHP,
    TLASTP   => TLASTP,
    TDATAI   => TDATAI,
    TDONEP   => TDONEP,
    TREADDP   => TREADDP,
    TRNSMTP  => TRNSMTP,
    TSTARTP  => TSTARTP,
    TDATAO   => TDATAO);
    
CLK_process :process
begin
    CLK <= not(CLK);
    wait for CLK_period/2;
end process;    

stim_proc :process
begin
    RESET <= '1', '0' after 10 ns, '1' after 20 ns;
    TAVAILP <='0', '1' after 30 ns, '0' after 40 ns;
        
    TDATAI <= X"F3", X"35" after 200 ns, X"D3" after 280 ns, 
    X"29" after 360 ns, X"A6" after 440 ns, X"12" after 520 ns, X"0" after 600ns,
    X"35" after 1080 ns, X"D3" after 1160 ns, 
    X"29" after 1240 ns, X"A6" after 1320 ns, X"12" after 1400 ns, X"0" after 1480ns;
    
    TLASTP <= '0', '1' after 1480 ns, '0' after 1490 ns;
    TFINISHP <= '0';
    wait;
end process;

end Behavioral;
