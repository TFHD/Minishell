NAME		:= 	minishell

OBJS_DIR	:= .objs/

DIR			:=	srcs/

DIRB		:=	srcs_bonus/

SRCS		:= 	leak_protector/leak_protector.c \
				leak_protector/leak_protector_list.c \
				leak_protector/func/lp_strdup.c \
				leak_protector/func/lp_strsjoin.c \
				parsing/ast/ast_tree.c \
				parsing/ast/ast_utils.c \
				parsing/ast/command_builder.c \
				parsing/ast/redirection_list.c \
				parsing/token/token_args.c \
				parsing/token/token_error.c \
				parsing/token/token_list.c \
				parsing/token/token_parser_utils.c \
				parsing/token/token_parser.c \
				parsing/quotes/parsing_quote.c \
				parsing/expand/expand.c \
				shell/env/create_env.c \
				shell/env/env_list.c \
				shell/env/env_utils.c \
				shell/prompt/prompt_builder.c \
				shell/prompt/prompt.c \
				shell/builtins/exec.c \
				shell/builtins/exec_utils.c \
				shell/builtins/builtins.c \
				shell/builtins/pwd.c \
				shell/builtins/cd.c \
				shell/builtins/echo.c \
				shell/builtins/export.c \
				shell/builtins/unset.c \
				shell/builtins/exit.c \
				shell/builtins/env.c \
				main.c \
			
OBJS		:=	$(patsubst %.c, $(OBJS_DIR)%.o, $(SRCS))

CC			:= cc

FLAGS 		:= -Wall -Werror -Wextra -I includes -g

LIB			:= lib/libft/libft.a

TPUT 					= tput -T xterm-256color
_RESET 					:= $(shell $(TPUT) sgr0)
_BOLD 					:= $(shell $(TPUT) bold)
_ITALIC 				:= $(shell $(TPUT) sitm)
_UNDER 					:= $(shell $(TPUT) smul)
_GREEN 					:= $(shell $(TPUT) setaf 2)
_YELLOW 				:= $(shell $(TPUT) setaf 3)
_RED 					:= $(shell $(TPUT) setaf 1)
_GRAY 					:= $(shell $(TPUT) setaf 8)
_PURPLE 				:= $(shell $(TPUT) setaf 5)

OBJS_TOTAL	= $(words $(OBJS))
N_OBJS		:= $(shell find $(DIR) -type f -name $(OBJS) 2>/dev/null | wc -l)
OBJS_TOTAL	:= $(shell echo $$(( $(OBJS_TOTAL) - $(N_OBJS) )))
CURR_OBJ	= 0

all: $(OBJS_DIR) ${NAME}

$(OBJS_DIR):
	@mkdir -p $(OBJS_DIR)
	@mkdir -p $(addprefix $(OBJS_DIR), $(dir $(SRCS)))

${NAME}: ${OBJS} ${LIB}
	@${CC} -o ${NAME} ${OBJS} ${LIB} -lreadline
	@printf "$(_BOLD)$(NAME)$(_RESET) compiled $(_GREEN)$(_BOLD)successfully$(_RESET)\n\n"

${LIB}:
	@printf "$(_BOLD)$(_UNDER)$(_YELLOW)                            LIBFT                           $(_RESET)\n"
	@make --no-print-directory -C lib/libft

${OBJS_DIR}%.o: ${DIR}%.c
	@${CC} ${FLAGS} -o $@ -c $<
	@$(eval CURR_OBJ=$(shell echo $$(( $(CURR_OBJ) + 1 ))))
	@$(eval PERCENT=$(shell echo $$(( $(CURR_OBJ) * 100 / $(OBJS_TOTAL) ))))
	@printf "$(_GREEN)($(_BOLD)%3s%%$(_RESET)$(_GREEN)) $(_RESET)Compiling $(_BOLD)$(_PURPLE)$<$(_RESET)\n" "$(PERCENT)"
	
clean:
	@rm -rf ${OBJS_DIR}
	@make --no-print-directory -C lib/libft clean
	@printf "\n$(_BOLD)All objects are $(_GREEN)cleaned $(_RESET)! 🎉\n\n"

fclean: clean
	@rm -f ${NAME}
	@make --no-print-directory -C lib/libft clean fclean
	@printf "Cleaned $(_BOLD)$(NAME)$(_RESET) !\n\n"

re: fclean all

.PHONY: clean fclean re all
