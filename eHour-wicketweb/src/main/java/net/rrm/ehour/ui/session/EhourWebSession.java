/**
 * Created on Jun 2, 2007
 * Created by Thies Edeling
 * Copyright (C) 2005, 2006 te-con, All Rights Reserved.
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; either version 2
 * of the License, or (at your option) any later version.
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
 * 
 * thies@te-con.nl
 * TE-CON
 * Legmeerstraat 4-2h, 1058ND, AMSTERDAM, The Netherlands
 *
 */

package net.rrm.ehour.ui.session;

import java.util.Calendar;
import java.util.GregorianCalendar;

import net.rrm.ehour.config.EhourConfig;
import net.rrm.ehour.user.domain.User;
import net.rrm.ehour.util.DateUtil;

import org.apache.wicket.Request;
import org.apache.wicket.injection.web.InjectorHolder;
import org.apache.wicket.protocol.http.WebApplication;
import org.apache.wicket.protocol.http.WebSession;
import org.apache.wicket.spring.injection.annot.SpringBean;

/**
 * TODO 
 **/

public class EhourWebSession extends /*Wasp*/WebSession
{
	@SpringBean
	private EhourConfig	ehourConfig;
	
	private	User		user;
	private	Calendar	navCalendar;
	private static final long serialVersionUID = 93189812483240412L;

	/**
	 * 
	 * @param app
	 * @param req
	 */
	public EhourWebSession(/*Wasp*/WebApplication app, Request req)
	{
		super(app, req);
		
		InjectorHolder.getInjector().inject(this);
	}
	
	/**
	 * Get ehour config
	 * @return
	 */
	public EhourConfig getEhourConfig()
	{
		return ehourConfig;
	}

	/**
	 * @return the navCalendar
	 */
	public Calendar getNavCalendar()
	{
		if (navCalendar == null)
		{
			navCalendar = DateUtil.getCalendar(ehourConfig);
			navCalendar = new GregorianCalendar();
			navCalendar.add(Calendar.MONTH, -2);
		}
		
		return (Calendar)navCalendar.clone();
	}

	/**
	 * @param navCalendar the navCalendar to set
	 */
	public void setNavCalendar(Calendar navCalendar)
	{
		this.navCalendar = navCalendar;
	}
	
	/**
	 * Get logged in user id
	 * TODO auth
	 * @return
	 */
	public User getUser()
	{
		if (user == null)
		{
			user = new User();
			user.setUserId(1);
			user.setFirstName("Thies");
			user.setLastName("Edeling");
		}
		
		return user;
	}
}
