----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 30.11.2022 17:27:12
-- Design Name: 
-- Module Name: TestRecepteur - Behavioral
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

entity TestRecepteur is
end TestRecepteur;

architecture Behavioral of TestRecepteur is

COMPONENT Recepteur
    PORT(  CLK      :   in  STD_LOGIC;
           RESET    :   in  STD_LOGIC;
           RBYTEP   :   out STD_LOGIC;
           RCLEANP  :   out STD_LOGIC;
           RCVNGP   :   out STD_LOGIC;
           RDATAO   :   out STD_LOGIC_VECTOR (7 downto 0);
           RDATAI   :   in STD_LOGIC_VECTOR (7 downto 0);
           RDONEP   :   out STD_LOGIC;
           RENABP   :   in  STD_LOGIC;
           RSTARTP  :   out STD_LOGIC;
           RSMATIP  :   out STD_LOGIC);
END COMPONENT;

--Input
signal CLK : std_logic := '0';
signal RESET : std_logic := '0';
signal RENABP : std_logic := '0';
signal RDATAI : std_logic_vector(7 downto 0) := (others => '0');

--Output
signal RBYTEP : std_logic;
signal RCLEANP : std_logic;
signal RCVNGP : std_logic;
signal RDONEP : std_logic;
signal RSTARTP : std_logic;
signal RSMATIP : std_logic;
signal RDATAO : std_logic_vector(7 downto 0);

--Clock period
constant CLK_period : time := 100 ns;

begin

uut : Recepteur PORT MAP (

    CLK     =>  CLK,
    RESET   =>  RESET,
    RENABP  =>  RENABP,
    RDATAI  =>  RDATAI,
    RBYTEP  =>  RBYTEP,
    RCLEANP =>  RCLEANP,
    RCVNGP  =>  RCVNGP,
    RDONEP  =>  RDONEP,
    RSTARTP =>  RSTARTP,
    RSMATIP =>  RSMATIP,
    RDATAO  =>  RDATAO);

CLK_process :process
begin
    CLK <= not(CLK);
    wait for CLK_period/2;
end process;  

stim_proc :process
begin
    RESET <= '1', '0' after 100 ns, '1' after 200 ns;
    RENABP <= '0', '1' after 500 ns, '0' after 600 ns;
    RDATAI <= "10101011";
    
    
    wait;
end process;

end Behavioral;
