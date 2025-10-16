--No.69 紋章神コート·オブ·アームズ
local s, id = GetID()
function s.initial_effect(c)
	--xyz summon
	Xyz.AddProcedure(c,nil,4,3)
	c:EnableReviveLimit()

	--cannot destroyed
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e0:SetValue(s.indes)
	c:RegisterEffect(e0)

	local e100=Effect.CreateEffect(c)
	e100:SetType(EFFECT_TYPE_SINGLE)
	e100:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e100:SetRange(LOCATION_MZONE)
	e100:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e100:SetValue(1)
	c:RegisterEffect(e100)

	--复制效果
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_ADJUST)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(s.sdcon)
	e4:SetOperation(s.sdop)
	c:RegisterEffect(e4)
	local e7=e4:Clone()
	e7:SetCode(EVENT_CHAIN_SOLVED)
	c:RegisterEffect(e7) 
	local e8=e4:Clone()
	e8:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e8) 
	local e9=e4:Clone()
	e9:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e9) 
	local e10=e4:Clone()
	e10:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e10)
	local e6=e4:Clone()
	e6:SetCondition(s.sdcon2)
	e6:SetOperation(s.sdop2)
	c:RegisterEffect(e6)

	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_DESTROY)
	e5:SetDescription(aux.Stringid(16037007,1))
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_ATTACK_ANNOUNCE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCondition(function(e,tp) return Duel.GetAttacker():IsControler(1-tp) end)
	e5:SetCost(Cost.DetachFromSelf(1))
	e5:SetTarget(s.sptg)
	e5:SetOperation(s.spop)
	c:RegisterEffect(e5)
	local e11=e5:Clone()
	e11:SetCode(EFFECT_TYPE_QUICK_O)
	e11:SetCode(EVENT_CHAINING)
	e11:SetCondition(s.spcon)
	c:RegisterEffect(e11)

	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,0))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetHintTiming(0,TIMING_STANDBY_PHASE|TIMING_MAIN_END|TIMINGS_CHECK_MONSTER_E)
	e3:SetCondition(s.spcon3)
	e3:SetCost(Cost.DetachFromSelf(1))
	e3:SetTarget(s.namechangetg)
	e3:SetOperation(s.namechangeop)
	c:RegisterEffect(e3)
end
s.xyz_number=69
s.listed_series = {0x48}
s.listed_names={CARD_UNKNOWN}

function s.indes(e,c)
	local ae={c:IsHasEffect(237)}
	local form=0
	if ae then
        for _, te in ipairs(ae) do
            if te:GetValue() and te:GetValue()>form then
                form=te:GetValue()
            end
        end
	end
	if form==2 then return true
	else return not e:GetHandler():GetBattleTarget():IsSetCard(0x48) end
end

function s.distarget(e,c)
	  return c~=e:GetHandler()
end

function s.sdfilter(c,e,tc)
	return c:IsFaceup()
		and not c:IsImmuneToEffect(e) and not c:IsDisabled()
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

function s.ocost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetAttacker():IsDestructable() end
	Duel.SetTargetCard(eg)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,tp,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not (c:IsFaceup() and c:IsRelateToEffect(e) and c:IsControler(tp) and not c:IsImmuneToEffect(e)) then return end
	local ae={c:IsHasEffect(237)}
	local form=0
	if ae then
        for _, te in ipairs(ae) do
            if te:GetValue() and te:GetValue()>form then
                form=te:GetValue()
            end
        end
	end
	if form<2 then 
		c:SetCardData(CARDDATA_PICCODE,406+form,0,RESET_EVENT+RESETS_STANDARD_DISABLE,c)
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(237,form+2))
		e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(237)
		e1:SetValue(form+1)
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
	local dg=Duel.GetFirstTarget()
	if dg:IsControler(1-tp) and dg:IsRelateToEffect(e) then
		Duel.Destroy(dg,REASON_EFFECT)
	end
end
-- function s.recover(e,tp,eg,ep,ev,re,r,rp)
-- 	local c=e:GetHandler()
-- 	if not c:IsOriginalCode(id) then
-- 		c:SetEntityCode(id,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,true)
-- 	end
-- end

function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	local ae={e:GetHandler():IsHasEffect(237)}
	local form=0
	if ae then
        for _, te in ipairs(ae) do
            if te:GetValue() and te:GetValue()>form then
                form=te:GetValue()
            end
        end
	end
	local ttype,tloc,tplayer=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_TYPE,CHAININFO_TRIGGERING_LOCATION,CHAININFO_TRIGGERING_CONTROLER)
	return ttype&TYPE_MONSTER>0 and tloc&LOCATION_ONFIELD>0 and tplayer==1-tp
	and form>=1
end

function s.spcon3(e,tp,eg,ep,ev,re,r,rp)
	local ae={e:GetHandler():IsHasEffect(237)}
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
function s.namechangefilter(c)
	return c:IsFaceup() and not c:IsCode(CARD_UNKNOWN)
end
function s.namechangetg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_MZONE) and s.namechangefilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.namechangefilter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,s.namechangefilter,tp,0,LOCATION_MZONE,1,1,nil)
end
function s.namechangeop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and not tc:IsCode(CARD_UNKNOWN) then
		--Its name becomes "Unknown"
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_CHANGE_CODE)
		e1:SetValue(CARD_UNKNOWN)
		e1:SetReset(RESET_EVENT|RESETS_STANDARD)
		tc:RegisterEffect(e1)
	end
end