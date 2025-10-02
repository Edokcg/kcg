--CNo.69 紋章死神カオス・オブ・アームズ
local s, id = GetID()
function s.initial_effect(c)
	--xyz summon
	aux.EnableCheckRankUp(c,nil,nil,2407234)
	Xyz.AddProcedure(c,nil,5,4)
	c:EnableReviveLimit()

	--cannot destroyed
	local e0=Effect.CreateEffect(c)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e0:SetRange(LOCATION_MZONE)
	e0:SetValue(s.indes)
	c:RegisterEffect(e0)
	local e02=e0:Clone()
	e02:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e02:SetValue(s.indes2)
	c:RegisterEffect(e02)

	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(11522979,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(s.descon)
	e1:SetCost(s.cost)
	e1:SetTarget(s.destg)
	e1:SetOperation(s.desop)
	e1:SetLabel(RESET_EVENT+RESETS_STANDARD)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_RANKUP_EFFECT)
	e3:SetLabelObject(e1)
	c:RegisterEffect(e3,false,EFFECT_MARKER_DETACH_XMAT)
	local e5=e1:Clone()
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_CHAINING)
	e5:SetCondition(s.spcon)
	local e6=e3:Clone()
	e6:SetLabelObject(e3)
	c:RegisterEffect(e6,false,EFFECT_MARKER_DETACH_XMAT)

	--effect
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(11522979,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCost(s.cost)
	e2:SetTarget(s.target)
	e2:SetOperation(s.operation)
	e2:SetLabel(RESET_EVENT+RESETS_STANDARD)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_RANKUP_EFFECT)
	e4:SetLabelObject(e2)
	c:RegisterEffect(e4,false,EFFECT_MARKER_DETACH_XMAT)

	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e7:SetCode(EVENT_ADJUST)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCondition(s.sdcon)
	e7:SetOperation(s.sdop)
	c:RegisterEffect(e7)
	local e8=e7:Clone()
	e8:SetCode(EVENT_CHAIN_SOLVED)
	c:RegisterEffect(e8) 
	local e9=e7:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9) 
	local e10=e7:Clone()
	e10:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e10) 
	local e11=e7:Clone()
	e11:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e11)
	local e12=e7:Clone()
	e12:SetCondition(s.sdcon2)
	e12:SetOperation(s.sdop2)
	c:RegisterEffect(e12)
end
s.xyz_number=69
s.listed_series = {0x48}
s.listed_names={84013237}

function s.indes(e,c)
	local ae={c:IsHasEffect(244)}
	local form=0
	if ae then
        for _, te in ipairs(ae) do
            if te:GetValue() and te:GetValue()>form then
                form=te:GetValue()
            end
        end
	end
	if form==2 then return true
	else return not e:GetHandler():GetBattleTarget():IsSetCard(0x48) 
	  and not e:GetHandler():GetBattleTarget():IsSetCard(0x1048) and not e:GetHandler():GetBattleTarget():IsSetCard(0x2048) end
end
function s.indes2(e,c)
	local ae={c:IsHasEffect(244)}
	local form=0
	if ae then
        for _, te in ipairs(ae) do
            if te:GetValue() and te:GetValue()>form then
                form=te:GetValue()
            end
        end
	end
	return form==2
end

function s.descon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker():IsControler(1-tp)
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	local ttype,tloc,tplayer=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_TYPE,CHAININFO_TRIGGERING_LOCATION,CHAININFO_TRIGGERING_CONTROLER)
	return ttype&TYPE_MONSTER>0 and tloc&LOCATION_ONFIELD>0 and tplayer==1-tp and not e:GetHandler():IsStatus(STATUS_CHAINING) 
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not (c:IsFaceup() and c:IsRelateToEffect(e) and c:IsControler(tp) and not c:IsImmuneToEffect(e)) then return end
	local ae={c:IsHasEffect(244)}
	local form=0
	if ae then
        for _, te in ipairs(ae) do
            if te:GetValue() and te:GetValue()>form then
                form=te:GetValue()
				break
            end
        end
	end
	if form<2 then 
		c:SetCardData(CARDDATA_PICCODE,408,0,RESET_EVENT+RESETS_STANDARD_DISABLE,c)
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(237,3))
		e1:SetProperty(EFFECT_FLAG_CLIENT_HINT+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(408)
		e1:SetValue(2)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD_DISABLE)
		c:RegisterEffect(e1, true)
	end
	-- local e8 = Effect.CreateEffect(c)
	-- e8:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE + EFFECT_FLAG_DAMAGE_STEP + EFFECT_FLAG_DAMAGE_CAL)
	-- e8:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_CONTINUOUS)
	-- e8:SetCode(EVENT_LEAVE_FIELD_P)
	-- e8:SetOperation(s.recover)
	-- e8:SetReset(RESET_EVENT + 0x1fe0000)
	-- c:RegisterEffect(e8, true)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
	Duel.Destroy(g,REASON_EFFECT)
end
-- function s.recover(e,tp,eg,ep,ev,re,r,rp)
-- 	local c=e:GetHandler()
-- 	if not c:IsOriginalCode(id) then
-- 		c:SetEntityCode(id,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,true)
-- 	end
-- end

function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function s.filter(c)
	return c:IsFaceup()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and s.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.filter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,s.filter,tp,0,LOCATION_MZONE,1,1,nil)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsFaceup() and c:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local code=tc:GetOriginalCode()
		local atk=tc:GetAttack()
		if atk<0 then atk=0 end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_CHANGE_CODE)
		e1:SetValue(code)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN)
		c:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_UPDATE_ATTACK)
		e2:SetValue(atk)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN)
		c:RegisterEffect(e2)
		c:CopyEffect(code,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,1)
	end
end

function s.sdfilter(c,e,tc)
	return c:IsFaceup()
		and not c:IsImmuneToEffect(e) and (not c:IsDisabled() or not c:IsCode(CARD_UNKNOWN))
end
function s.sdcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(s.sdfilter,tp,LOCATION_MZONE,LOCATION_MZONE,c,e,c)
	return g:GetCount()>0
end
function s.sdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(s.sdfilter,tp,LOCATION_MZONE,LOCATION_MZONE,c,e,c)
	if g:GetCount()>0 then 
		local tc=g:GetFirst()
		while tc do
			local e1=Effect.CreateEffect(c)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_OWNER_RELATE)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetCondition(s.dcon)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e1)
			if tc:IsStatus(STATUS_DISABLED) then 
				local e2=e1:Clone()
				e2:SetCode(EFFECT_DISABLE_EFFECT)
				tc:RegisterEffect(e2)
				c:SetCardTarget(tc)
				c:CopyEffect(tc:GetOriginalCode(),RESET_EVENT+RESETS_STANDARD,1)
			end
			local e3=e1:Clone()
			e3:SetCode(EFFECT_CHANGE_CODE)
			e3:SetValue(CARD_UNKNOWN)
			tc:RegisterEffect(e3)
			tc=g:GetNext()
		end
	end
end
function s.dcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetOwner()
	return not c:IsStatus(STATUS_DISABLED)
end
function s.sdfilter2(c)
	return c:IsFaceup() and not c:IsDisabled() and c:IsLocation(LOCATION_MZONE)
end
function s.sdcon2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=c:GetCardTarget()
	if g:GetCount()<1 then return false end
	local g2=g:Filter(s.sdfilter2,c)
	return g2:GetCount()>0
end
function s.sdop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=c:GetCardTarget()
	if g:GetCount()<1 then return end
	local g2=g:Filter(s.sdfilter2,c)
	if g2:GetCount()>0 then 
		local tc=g2:GetFirst()
		while tc do
			c:CancelCardTarget(tc)
			tc=g2:GetNext()
		end
	end
end