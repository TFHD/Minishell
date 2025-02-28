/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   env_utils.c                                        :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: albernar <marvin@42.fr>                    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2024/12/03 19:46:43 by albernar          #+#    #+#             */
/*   Updated: 2025/02/04 09:36:28 by albernar         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "shell.h"

char	*get_env_name(char *env_name)
{
	char	*name;
	int		i;

	i = 0;
	while (*(env_name + i) && *(env_name + i) != '=')
		i++;
	name = lp_substr(env_name, 0, i);
	return (name);
}

char	*get_env(t_env_list *env_list, char *env_name)
{
	t_env_list	*current;
	size_t		env_name_size;
	char		*name;

	if (!env_list)
		return (NULL);
	current = env_list;
	env_name_size = ft_strlen(env_name);
	while (current)
	{
		name = get_env_name((char *)current->content);
		if (!ft_strcmp(name, env_name))
		{
			lp_free(name);
			return (current->content + env_name_size + 1);
		}
		current = current->next;
		lp_free(name);
	}
	return (NULL);
}

void	set_env(t_env_list *env_list, char *env_name, char *new)
{
	t_env_list	*current;
	size_t		env_name_size;

	if (!env_list)
		return ;
	current = env_list;
	env_name_size = ft_strlen(env_name);
	while (current)
	{
		if (ft_strnstr((char *)current->content, env_name, env_name_size))
		{
			lp_free(current->content);
			current->content = lp_alloc(sizeof(char *),
					env_name_size + ft_strlen(new) + 2);
			ft_strcpy(current->content, env_name);
			ft_strcat(current->content, "=");
			ft_strcat(current->content, new);
		}
		current = current->next;
	}
}

char	**env_list_to_char(t_env_list *head, char *remove)
{
	char		**envp;
	t_env_list	*current;
	t_env_list	*tmp;
	int			i;

	i = 0;
	current = head;
	while (current)
	{
		current = current->next;
		i++;
	}
	envp = lp_alloc(sizeof(char *), i + 1);
	current = head;
	i = 0;
	while (current)
	{
		tmp = current;
		current = current->next;
		if (!ft_strnstr(tmp->content, remove, ft_strlen(remove)))
			envp[i++] = lp_strdup(tmp->content);
	}
	envp[i] = 0;
	return (envp);
}
