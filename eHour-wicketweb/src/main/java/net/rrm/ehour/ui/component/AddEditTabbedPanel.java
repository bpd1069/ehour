/**
 * Created on Aug 19, 2007
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

package net.rrm.ehour.ui.component;

import java.util.ArrayList;

import net.rrm.ehour.ui.model.AdminBackingBean;
import net.rrm.ehour.ui.panel.admin.NoEntrySelectedPanel;

import org.apache.wicket.ajax.AjaxRequestTarget;
import org.apache.wicket.ajax.markup.html.AjaxFallbackLink;
import org.apache.wicket.extensions.ajax.markup.html.tabs.AjaxTabbedPanel;
import org.apache.wicket.extensions.markup.html.tabs.AbstractTab;
import org.apache.wicket.markup.html.WebMarkupContainer;
import org.apache.wicket.markup.html.panel.Panel;
import org.apache.wicket.model.ResourceModel;

/**
 * AjaxTabbedPanel that passes the index to a pre process method
 **/
@SuppressWarnings({"unchecked", "serial"})
public abstract class AddEditTabbedPanel extends AjaxTabbedPanel
{
	private static final long serialVersionUID = -2437819961082840272L;

	private AdminBackingBean	addBackingBean;
	private AdminBackingBean	editBackingBean;
	private	ResourceModel		addTabTitle;
	private	ResourceModel		editTabTitle;
	
	/**
	 * 
	 * @param id
	 * @param tabs
	 */
	public AddEditTabbedPanel(String id, ResourceModel addTabTitle, ResourceModel editTabTitle)
	{
		super(id, new ArrayList<AbstractTab>());
		
		this.addTabTitle = addTabTitle;
		this.editTabTitle = editTabTitle;
		
		addBackingBean = getNewAddBackingBean();
		editBackingBean = getNewEditBackingBean();
		
		setUpTabs();
	}
	
	/**
	 * Successful save
	 * @param target
	 */
	public void succesfulSave(AjaxRequestTarget target)
	{
		getAddBackingBean().setServerMessage(getLocalizer().getString("dataSaved", this));
		addAddTab();
		setSelectedTab(0);
		
		target.addComponent(this);
	}

	/**
	 * Failed save
	 * @param target
	 */
	public void failedSave(AdminBackingBean backingBean, AjaxRequestTarget target)
	{
		backingBean.setServerMessage(getLocalizer().getString("saveError", this));
		target.addComponent(this);
	}	
	
	
	/**
	 * Setup tabs
	 */
	private void setUpTabs()
	{
		addAddTab();
		addNoUserTab();
	}	
	
	/**
	 * Add add tab at position 0
	 */
	private void addAddTab()
	{
		removeTab(0);
		
		AbstractTab addTab = new AbstractTab(addTabTitle)
		{
			@Override
			public Panel getPanel(String panelId)
			{
				return getAddPanel(panelId);
			}
		};

		getTabs().add(0, addTab);	
	}	
	
	/**
	 * Get the panel for the add tab
	 * @param panelId
	 * @return
	 */
	protected abstract Panel getAddPanel(String panelId);
	
	/**
	 * Add no user selected tab at position 1
	 */
	protected void addNoUserTab()
	{
		removeTab(1);
		
		AbstractTab editTab = new AbstractTab(editTabTitle)
		{
			@Override
			public Panel getPanel(String panelId)
			{
				return getNoSelectionPanel(panelId);
			}
		};

		getTabs().add(1, editTab);		
	}	
	
	/**
	 * Get the panel for the no-selection-made-yet tab (edit tab but no entity selected yet)
	 * @param panelId
	 * @return
	 */
	protected Panel getNoSelectionPanel(String panelId)
	{
		return new NoEntrySelectedPanel(panelId);
	}	
	
	/*
	 * (non-Javadoc)
	 * @see org.apache.wicket.extensions.ajax.markup.html.tabs.AjaxTabbedPanel#newLink(java.lang.String, int)
	 */
	@Override
	protected WebMarkupContainer newLink(String linkId, final int index)
	{
		return new AjaxFallbackLink(linkId)
		{

			private static final long serialVersionUID = 1L;

			public void onClick(AjaxRequestTarget target)
			{
				preProcessTabSwitch(index);
				
				setSelectedTab(index);
				
				if (target != null)
				{
					target.addComponent(AddEditTabbedPanel.this);
				}
				onAjaxUpdate(target);
			}

		};
	}
	
	/**
	 * 
	 * @param target
	 * @param index
	 */
	protected void preProcessTabSwitch(int index)
	{
		// if "Add" tab is clicked again, reset the backing bean as it's
		// only way out if for some reason the save went wrong and the page is stuck on
		// an error
		if (getSelectedTab() == index && index == 0)
		{
			addBackingBean = getNewAddBackingBean();
		}
		
		// reset server messages
		addBackingBean.setServerMessage(null);
		editBackingBean.setServerMessage(null);
	}	
	
	/**
	 * Removes tab from specified position
	 * @param index
	 */
	public void removeTab(int index)
	{
		if (getTabs().size() >= index + 1)
		{
			getTabs().remove(index);;
		}
	}
	
	/**
	 * Switch tab
	 * @param tab
	 * @param userId
	 */
	public void switchTabOnAjaxTarget(AjaxRequestTarget target, int tabIndex)
	{
		if (tabIndex == 1)
		{
			addEditTab();
		}
		
		setSelectedTab(tabIndex);
		target.addComponent(this);
	}
	
	/**
	 * Add edit tab at position 1
	 */
	private void addEditTab()
	{
		removeTab(1);
		
		AbstractTab editTab = new AbstractTab(editTabTitle)
		{
			@Override
			public Panel getPanel(String panelId)
			{
				return getEditPanel(panelId);
			}
		};

		getTabs().add(1, editTab);		
	}	
	
	/**
	 * Get the backing bean for the add panel
	 * @return
	 */
	protected abstract AdminBackingBean getNewAddBackingBean();
	
	
	/**
	 * Get the panel for the edit tab
	 * @param panelId
	 * @return
	 */
	protected abstract Panel getEditPanel(String panelId);	
	
	/**
	 * 
	 * @return
	 */
	public AdminBackingBean getAddBackingBean()
	{
		return addBackingBean;
	}	
	
	/**
	 * 
	 * @return
	 */
	public AdminBackingBean getEditBackingBean()
	{
		return editBackingBean;
	}	
	
	
	/**
	 * Get the backing bean for the edit panel
	 * @return
	 */
	protected abstract AdminBackingBean getNewEditBackingBean();

	/**
	 * @param editBackingBean the editBackingBean to set
	 */
	public void setEditBackingBean(AdminBackingBean editBackingBean)
	{
		this.editBackingBean = editBackingBean;
	}	
}

