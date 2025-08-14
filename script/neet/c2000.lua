--陽光の下での寄り添い
local s,id=GetID()
function s.initial_effect(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_STARTUP)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetOperation(s.op)
	Duel.RegisterEffect(e1,0)   
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	local c = e:GetOwner()
	local p = c:GetControler()
	Duel.DisableShuffleCheck()
	Duel.SendtoDeck(c,nil,-2,REASON_RULE)
	local ct = Duel.GetMatchingGroupCount(nil,p,LOCATION_HAND+LOCATION_DECK,0,c)
	if (Duel.IsDuelType(DUEL_MODE_SPEED) and ct < 20 or ct < 40) and Duel.SelectYesNo(1-p, aux.Stringid(4014,5)) then
		Duel.Win(1-p,0x55)
	end
	if c:IsPreviousLocation(LOCATION_HAND) then Duel.Draw(p, 1, REASON_RULE) end
	e:Reset()
end
----Spright
--Spright Red
if not c75922381 then
	c75922381 = {}
	setmetatable(c75922381,Card)
	rawset(c75922381,"__index",c75922381)
	function c75922381.initial_effect(c)
		--Special Summon self
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_SPSUMMON_PROC)
		e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
		e1:SetRange(LOCATION_HAND)
		e1:SetCountLimit(1,75922381,EFFECT_COUNT_CODE_OATH)
		e1:SetCondition(c75922381.spcon)
		c:RegisterEffect(e1)
		--Negate monster effect
		local e2=Effect.CreateEffect(c)
		e2:SetDescription(aux.Stringid(75922381,0))
		e2:SetCategory(CATEGORY_DISABLE+CATEGORY_DESTROY)
		e2:SetType(EFFECT_TYPE_QUICK_O)
		e2:SetCode(EVENT_CHAINING)
		e2:SetRange(LOCATION_MZONE)
		e2:SetCountLimit(1,{75922381,1})
		e2:SetCondition(c75922381.discon)
		e2:SetCost(c75922381.discost)
		e2:SetTarget(c75922381.distg)
		e2:SetOperation(c75922381.disop)
		c:RegisterEffect(e2)
	end
	function c75922381.spconfilter(c)
		return c:IsFaceup() and (c:IsLevel(2) or c:IsLink(2))
	end
	function c75922381.spcon(e,c)
		if c==nil then return true end
		local tp=e:GetHandlerPlayer()
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c75922381.spconfilter,tp,LOCATION_MZONE,0,1,nil)
	end
	function c75922381.discon(e,tp,eg,ep,ev,re,r,rp)
		return rp==1-tp and re:IsMonsterEffect() and Duel.IsChainDisablable(ev) 
	end
	function c75922381.discostfilter(c)
		return c:IsLevel(2) or c:IsRank(2) or c:IsLink(2)
	end
	function c75922381.discost(e,tp,eg,ep,ev,re,r,rp,chk)
		local c=e:GetHandler()
		local b1=Duel.CheckReleaseGroupCost(tp,c75922381.discostfilter,1,false,nil,c)
		local b2=Duel.IsPlayerAffectedByEffect(tp,1907) and Duel.GetFlagEffect(tp,1907)==0
		if chk==0 then return b1 or b2 end
		local op=1
		if b1 and b2 and Duel.SelectYesNo(tp,aux.Stringid(1907,0)) then
			op=0
			e:SetLabel(1)
			Duel.Hint(HINT_CARD,tp,1907)
			Duel.RegisterFlagEffect(tp,1907,RESET_PHASE|PHASE_END,0,1)
		elseif b2 and not b1 then
			op=0
			e:SetLabel(1)
			Duel.Hint(HINT_CARD,tp,1907)
			Duel.RegisterFlagEffect(tp,1907,RESET_PHASE|PHASE_END,0,1)
		end
		if op==1 then
			local rc=Duel.SelectReleaseGroupCost(tp,c75922381.discostfilter,1,1,false,nil,c):GetFirst()
			e:SetLabel(rc:GetLevel())
			Duel.Release(rc,REASON_COST)
		end
	end
	function c75922381.distg(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return not re:GetHandler():IsDisabled() end
		Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
	end
	function c75922381.disop(e,tp,eg,ep,ev,re,r,rp)
		if Duel.NegateEffect(ev) and re:GetHandler():IsRelateToEffect(re)
			and e:GetLabel()==0 and Duel.SelectYesNo(tp,aux.Stringid(75922381,1)) then
			Duel.BreakEffect()
			Duel.Destroy(eg,REASON_EFFECT)
		end
	end
end
--Spright Carrot
if not c2311090 then
	c2311090 = {}
	setmetatable(c2311090,Card)
	rawset(c2311090,"__index",c2311090)
	function c2311090.initial_effect(c)
		--Special Summon self
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_SPSUMMON_PROC)
		e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
		e1:SetRange(LOCATION_HAND)
		e1:SetCountLimit(1,2311090,EFFECT_COUNT_CODE_OATH)
		e1:SetCondition(c2311090.spcon)
		c:RegisterEffect(e1)
		--Negate Spell/Trap effect
		local e2=Effect.CreateEffect(c)
		e2:SetDescription(aux.Stringid(id,0))
		e2:SetCategory(CATEGORY_DISABLE+CATEGORY_DESTROY)
		e2:SetType(EFFECT_TYPE_QUICK_O)
		e2:SetCode(EVENT_CHAINING)
		e2:SetRange(LOCATION_MZONE)
		e2:SetCountLimit(1,{2311090,1})
		e2:SetCondition(c2311090.discon)
		e2:SetCost(c2311090.discost)
		e2:SetTarget(c2311090.distg)
		e2:SetOperation(c2311090.disop)
		c:RegisterEffect(e2)
	end
	function c2311090.spconfilter(c)
		return c:IsFaceup() and (c:IsLevel(2) or c:IsLink(2))
	end
	function c2311090.spcon(e,c)
		if c==nil then return true end
		local tp=e:GetHandlerPlayer()
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c2311090.spconfilter,tp,LOCATION_MZONE,0,1,nil)
	end
	function c2311090.discon(e,tp,eg,ep,ev,re,r,rp)
		return rp==1-tp and re:IsSpellTrapEffect() and Duel.IsChainDisablable(ev) 
	end
	function c2311090.discostfilter(c)
		return c:IsLevel(2) or c:IsRank(2) or c:IsLink(2)
	end
	function c2311090.discost(e,tp,eg,ep,ev,re,r,rp,chk)
		local c=e:GetHandler()
		local b1=Duel.CheckReleaseGroupCost(tp,c2311090.discostfilter,1,false,nil,c)
		local b2=Duel.IsPlayerAffectedByEffect(tp,1907) and Duel.GetFlagEffect(tp,1907)==0
		if chk==0 then return b1 or b2 end
		local op=1
		if b1 and b2 and Duel.SelectYesNo(tp,aux.Stringid(1907,0)) then
			op=0
			e:SetLabel(1)
			Duel.Hint(HINT_CARD,tp,1907)
			Duel.RegisterFlagEffect(tp,1907,RESET_PHASE|PHASE_END,0,1)
		elseif b2 and not b1 then
			op=0
			e:SetLabel(1)
			Duel.Hint(HINT_CARD,tp,1907)
			Duel.RegisterFlagEffect(tp,1907,RESET_PHASE|PHASE_END,0,1)
		end
		if op==1 then
			local rc=Duel.SelectReleaseGroupCost(tp,c2311090.discostfilter,1,1,false,nil,c):GetFirst()
			e:SetLabel(rc:GetLevel())
			Duel.Release(rc,REASON_COST)
		end
	end
	function c2311090.distg(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return not re:GetHandler():IsDisabled() end
		Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
	end
	function c2311090.disop(e,tp,eg,ep,ev,re,r,rp)
		if Duel.NegateEffect(ev) and re:GetHandler():IsRelateToEffect(re)
			and e:GetLabel()==0 and Duel.SelectYesNo(tp,aux.Stringid(2311090,1)) then
			Duel.BreakEffect()
			Duel.Destroy(eg,REASON_EFFECT)
		end
	end
end

--Hieratic
--Hieratic Dragon of Su
if not c3300267 then
	c3300267 = {}
	setmetatable(c3300267,Card)
	rawset(c3300267,"__index",c3300267)
	function c3300267.initial_effect(c)
		--Special Summon procedure
		local e1=Effect.CreateEffect(c)
		e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetRange(LOCATION_HAND)
		e1:SetCode(EFFECT_SPSUMMON_PROC)
		e1:SetCondition(c3300267.hspcon)
		e1:SetTarget(c3300267.hsptg)
		e1:SetOperation(c3300267.hspop)
		c:RegisterEffect(e1)
		--Destroy 1 Spell/Trap
		local e2=Effect.CreateEffect(c)
		e2:SetDescription(aux.Stringid(3300267,0))
		e2:SetCategory(CATEGORY_DESTROY)
		e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
		e2:SetType(EFFECT_TYPE_IGNITION)
		e2:SetRange(LOCATION_MZONE)
		e2:SetCountLimit(1)
		e2:SetCost(c3300267.descost)
		e2:SetTarget(c3300267.destg)
		e2:SetOperation(c3300267.desop)
		c:RegisterEffect(e2)
		--Special Summon 1 Dragon Normal Monster from your hand/Deck/GY
		local e3=Effect.CreateEffect(c)
		e3:SetDescription(aux.Stringid(3300267,1))
		e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
		e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
		e3:SetCode(EVENT_RELEASE)
		e3:SetTarget(c3300267.sptg)
		e3:SetOperation(c3300267.spop)
		c:RegisterEffect(e3)
	end
	c3300267.listed_series={SET_HIERATIC}
	function c3300267.hspcon(e,c)
		if c==nil then return true end
		return Duel.CheckReleaseGroup(c:GetControler(),Card.IsSetCard,1,false,1,true,c,c:GetControler(),nil,false,e:GetHandler(),SET_HIERATIC)
	end
	function c3300267.hsptg(e,tp,eg,ep,ev,re,r,rp,c)
		local g=Duel.SelectReleaseGroup(tp,Card.IsSetCard,1,1,false,true,true,c,nil,nil,false,e:GetHandler(),SET_HIERATIC)
		if g then
			g:KeepAlive()
			e:SetLabelObject(g)
		return true
		end
		return false
	end
	function c3300267.hspop(e,tp,eg,ep,ev,re,r,rp,c)
		local g=e:GetLabelObject()
		if not g then return end
		Duel.Release(g,REASON_COST)
		g:DeleteGroup()
	end
	function c3300267.descfilter(c)
		return c:IsSetCard(SET_HIERATIC)
	end
	function c3300267.descost(e,tp,eg,ep,ev,re,r,rp,chk)
		local dg=Duel.GetMatchingGroup(c3300267.desfilter,tp,0,LOCATION_ONFIELD,nil,e)
		if chk==0 then return Duel.CheckReleaseGroupCost(tp,c3300267.descfilter,1,true,aux.ReleaseCheckTarget,e:GetHandler(),dg) end
		local g=Duel.SelectReleaseGroupCost(tp,c3300267.descfilter,1,1,true,aux.ReleaseCheckTarget,e:GetHandler(),dg)
		Duel.Release(g,REASON_COST)
	end
	function c3300267.desfilter(c,e)
		return c:IsSpellTrap() and (not e or c:IsCanBeEffectTarget(e))
	end
	function c3300267.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
		if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) and c3300267.desfilter(chkc) end
		if chk==0 then return Duel.IsExistingTarget(c3300267.desfilter,tp,0,LOCATION_ONFIELD,1,nil) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g=Duel.SelectTarget(tp,c3300267.desfilter,tp,0,LOCATION_ONFIELD,1,1,nil)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	end
	function c3300267.desop(e,tp,eg,ep,ev,re,r,rp)
		local tc=Duel.GetFirstTarget()
		if tc and tc:IsRelateToEffect(e) then
			Duel.Destroy(tc,REASON_EFFECT)
		end
	end
	function c3300267.spfilter(c,e,tp,chk)
		return (chk or c:IsType(TYPE_NORMAL)) and c:IsRace(RACE_DRAGON) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	end
	function c3300267.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return true end
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND|LOCATION_DECK|LOCATION_GRAVE)
	end
	function c3300267.spop(e,tp,eg,ep,ev,re,r,rp)
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
		Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT)
		local chk=Duel.IsPlayerAffectedByEffect(tp,1331)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c3300267.spfilter),tp,LOCATION_HAND|LOCATION_DECK|LOCATION_GRAVE,0,1,1,nil,e,tp,chk)
		local tc=g:GetFirst()
		if not tc then return end
		if Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SET_ATTACK)
			e1:SetValue(0)
			e1:SetReset(RESET_EVENT|RESETS_STANDARD)
			tc:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_SET_DEFENSE)
			tc:RegisterEffect(e2)
		end
		Duel.SpecialSummonComplete()
	end
end
--Hieratic Dragon of Tefnuit
if not c77901552 then
	c77901552 = {}
	setmetatable(c77901552,Card)
	rawset(c77901552,"__index",c77901552)
	function c77901552.initial_effect(c)
		--Special summon itself from hand
		local e1=Effect.CreateEffect(c)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetRange(LOCATION_HAND)
		e1:SetCode(EFFECT_SPSUMMON_PROC)
		e1:SetCondition(c77901552.hspcon)
		e1:SetOperation(c77901552.hspop)
		c:RegisterEffect(e1)
		--If tributed, special summon 1 dragon normal monster from hand, deck, or GY
		local e2=Effect.CreateEffect(c)
		e2:SetDescription(aux.Stringid(77901552,0))
		e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
		e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
		e2:SetCode(EVENT_RELEASE)
		e2:SetTarget(c77901552.sptg)
		e2:SetOperation(c77901552.spop)
		c:RegisterEffect(e2)
	end
	function c77901552.hspcon(e,c)
		if c==nil then return true end
		local tp=c:GetControler()
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0
			and Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)~=0
	end
	function c77901552.hspop(e,tp,eg,ep,ev,re,r,rp,c)
		--Cannot attack this turn
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(3206)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
		e1:SetCode(EFFECT_CANNOT_ATTACK)
		e1:SetReset(RESET_EVENT|RESETS_STANDARD-RESET_TOFIELD|RESET_PHASE|PHASE_END)
		c:RegisterEffect(e1)
	end
	function c77901552.spfilter(c,e,tp,chk)
		return (chk or c:IsType(TYPE_NORMAL)) and c:IsRace(RACE_DRAGON) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	end
	function c77901552.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return true end
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND|LOCATION_DECK|LOCATION_GRAVE)
	end
	function c77901552.spop(e,tp,eg,ep,ev,re,r,rp)
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local chk=Duel.IsPlayerAffectedByEffect(tp,1331)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c3300267.spfilter),tp,LOCATION_HAND|LOCATION_DECK|LOCATION_GRAVE,0,1,1,nil,e,tp,chk)
		local tc=g:GetFirst()
		if tc and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SET_ATTACK)
			e1:SetValue(0)
			e1:SetReset(RESET_EVENT|RESETS_STANDARD)
			tc:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_SET_DEFENSE)
			tc:RegisterEffect(e2)
		end
		Duel.SpecialSummonComplete()
	end
end
--Hieratic Dragon of Nebthet
if not c31516413 then
	c31516413 = {}
	setmetatable(c31516413,Card)
	rawset(c31516413,"__index",c31516413)
	function c31516413.initial_effect(c)
		--spsummon from hand
		local e1=Effect.CreateEffect(c)
		e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetRange(LOCATION_HAND)
		e1:SetCode(EFFECT_SPSUMMON_PROC)
		e1:SetCondition(c31516413.hspcon)
		e1:SetTarget(c31516413.hsptg)
		e1:SetOperation(c31516413.hspop)
		c:RegisterEffect(e1)
		--destroy
		local e2=Effect.CreateEffect(c)
		e2:SetDescription(aux.Stringid(31516413,0))
		e2:SetCategory(CATEGORY_DESTROY)
		e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
		e2:SetType(EFFECT_TYPE_IGNITION)
		e2:SetRange(LOCATION_MZONE)
		e2:SetCountLimit(1)
		e2:SetCost(c31516413.descost)
		e2:SetTarget(c31516413.destg)
		e2:SetOperation(c31516413.desop)
		c:RegisterEffect(e2)
		--spsummon
		local e3=Effect.CreateEffect(c)
		e3:SetDescription(aux.Stringid(31516413,1))
		e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
		e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
		e3:SetCode(EVENT_RELEASE)
		e3:SetTarget(c31516413.sptg)
		e3:SetOperation(c31516413.spop)
		c:RegisterEffect(e3)
	end
	c31516413.listed_series={SET_HIERATIC}
	function c31516413.hspcon(e,c)
		if c==nil then return true end
		return Duel.CheckReleaseGroup(c:GetControler(),Card.IsSetCard,1,false,1,true,c,c:GetControler(),nil,false,e:GetHandler(),SET_HIERATIC)
	end
	function c31516413.hsptg(e,tp,eg,ep,ev,re,r,rp,c)
		local g=Duel.SelectReleaseGroup(tp,Card.IsSetCard,1,1,false,true,true,c,nil,nil,false,e:GetHandler(),SET_HIERATIC)
		if g then
			g:KeepAlive()
			e:SetLabelObject(g)
		return true
		end
		return false
	end
	function c31516413.hspop(e,tp,eg,ep,ev,re,r,rp,c)
		local g=e:GetLabelObject()
		if not g then return end
		Duel.Release(g,REASON_COST)
		g:DeleteGroup()
	end
	function c31516413.descfilter(c)
		return c:IsSetCard(SET_HIERATIC)
	end
	function c31516413.descost(e,tp,eg,ep,ev,re,r,rp,chk)
		local dg=Duel.GetMatchingGroup(Card.IsCanBeEffectTarget,tp,0,LOCATION_MZONE,nil,e)
		if chk==0 then return Duel.CheckReleaseGroupCost(tp,c31516413.descfilter,1,true,aux.ReleaseCheckTarget,e:GetHandler(),dg) end
		local g=Duel.SelectReleaseGroupCost(tp,c31516413.descfilter,1,1,true,aux.ReleaseCheckTarget,e:GetHandler(),dg)
		Duel.Release(g,REASON_COST)
	end
	function c31516413.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
		if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) end
		if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_MZONE,1,nil) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_MZONE,1,1,nil)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	end
	function c31516413.desop(e,tp,eg,ep,ev,re,r,rp)
		local tc=Duel.GetFirstTarget()
		if tc:IsRelateToEffect(e) then
			Duel.Destroy(tc,REASON_EFFECT)
		end
	end
	function c31516413.spfilter(c,e,tp,chk)
		return (chk or c:IsType(TYPE_NORMAL)) and c:IsRace(RACE_DRAGON) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	end
	function c31516413.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return true end
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND|LOCATION_DECK|LOCATION_GRAVE)
	end
	function c31516413.spop(e,tp,eg,ep,ev,re,r,rp)
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local chk=Duel.IsPlayerAffectedByEffect(tp,1331)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c3300267.spfilter),tp,LOCATION_HAND|LOCATION_DECK|LOCATION_GRAVE,0,1,1,nil,e,tp,chk)
		local tc=g:GetFirst()
		if not tc then return end
		if Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SET_ATTACK)
			e1:SetValue(0)
			e1:SetReset(RESET_EVENT|RESETS_STANDARD)
			tc:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_SET_DEFENSE)
			tc:RegisterEffect(e2)
		end
		Duel.SpecialSummonComplete()
	end
end
--Hieratic Dragon of Eset
if not c4022819 then
	c4022819 = {}
	setmetatable(c4022819,Card)
	rawset(c4022819,"__index",c4022819)
	function c4022819.initial_effect(c)
		--You can Normal Summon this card without Tributing, but its original ATK becomes 1000
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(4022819,0))
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
		e1:SetCode(EFFECT_SUMMON_PROC)
		e1:SetCondition(c4022819.ntcon)
		e1:SetOperation(c4022819.ntop)
		c:RegisterEffect(e1)
		--The Levels of all face-up "Hieratic" monsters currently on the field become the Level of 1 face-up Dragon Normal Monster on the field
		local e2=Effect.CreateEffect(c)
		e2:SetDescription(aux.Stringid(4022819,1))
		e2:SetCategory(CATEGORY_LVCHANGE)
		e2:SetType(EFFECT_TYPE_IGNITION)
		e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
		e2:SetRange(LOCATION_MZONE)
		e2:SetCountLimit(1)
		e2:SetTarget(c4022819.lvtg)
		e2:SetOperation(c4022819.lvop)
		c:RegisterEffect(e2)
		--Special Summon 1 Dragon Normal Monster from your hand, Deck, or GY, and make its ATK/DEF 0
		local e3=Effect.CreateEffect(c)
		e3:SetDescription(aux.Stringid(4022819,2))
		e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
		e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
		e3:SetCode(EVENT_RELEASE)
		e3:SetTarget(c4022819.sptg)
		e3:SetOperation(c4022819.spop)
		c:RegisterEffect(e3)
	end
	c4022819.listed_series={SET_HIERATIC}
	function c4022819.ntcon(e,c,minc)
		if c==nil then return true end
		return minc==0 and c:IsLevelAbove(5) and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
	end
	function c4022819.ntop(e,tp,eg,ep,ev,re,r,rp,c)
		--Its original ATK becomes 1000
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetCode(EFFECT_SET_BASE_ATTACK)
		e1:SetRange(LOCATION_MZONE)
		e1:SetValue(1000)
		e1:SetReset(RESET_EVENT|RESETS_STANDARD_DISABLE&~RESET_TOFIELD)
		c:RegisterEffect(e1)
	end
	function c4022819.lvfilter(c)
		return c:IsRace(RACE_DRAGON) and c:IsType(TYPE_NORMAL) and c:IsFaceup()
			and Duel.IsExistingMatchingCard(c4022819.hieraticfilter,0,LOCATION_MZONE,LOCATION_MZONE,1,nil,c:GetLevel())
	end
	function c4022819.hieraticfilter(c,lv)
		return c:IsSetCard(SET_HIERATIC) and c:HasLevel() and c:IsFaceup() and not c:IsLevel(lv)
	end
	function c4022819.lvtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
		if chkc then return chkc:IsLocation(LOCATION_MZONE) and c4022819.lvfilter(chkc) end
		if chk==0 then return Duel.IsExistingTarget(c4022819.lvfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		local tc=Duel.SelectTarget(tp,c4022819.lvfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil):GetFirst()
		local g=Duel.GetMatchingGroup(c4022819.hieraticfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,tc:GetLevel())
		Duel.SetOperationInfo(0,CATEGORY_LVCHANGE,g,#g,tp,tc:GetLevel())
	end
	function c4022819.lvop(e,tp,eg,ep,ev,re,r,rp)
		local tc=Duel.GetFirstTarget()
		if not tc:IsRelateToEffect(e) or tc:IsFacedown() then return end
		local g=Duel.GetMatchingGroup(c4022819.hieraticfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,tc:GetLevel())
		if #g==0 then return end
		local c=e:GetHandler()
		local lv=tc:GetLevel()
		for lc in g:Iter() do
			--Their Levels become the Level of that monster
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetCode(EFFECT_CHANGE_LEVEL)
			e1:SetValue(lv)
			e1:SetReset(RESETS_STANDARD_PHASE_END)
			lc:RegisterEffect(e1)
		end
	end
	function c4022819.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return true end
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND|LOCATION_DECK|LOCATION_GRAVE)
	end
	function c4022819.spfilter(c,e,tp,chk)
		return (chk or c:IsType(TYPE_NORMAL)) and c:IsRace(RACE_DRAGON) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	end
	function c4022819.spop(e,tp,eg,ep,ev,re,r,rp)
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local chk=Duel.IsPlayerAffectedByEffect(tp,1331)
		local sc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c4022819.spfilter),tp,LOCATION_HAND|LOCATION_DECK|LOCATION_GRAVE,0,1,1,nil,e,tp,chk):GetFirst()
		if sc and Duel.SpecialSummonStep(sc,0,tp,tp,false,false,POS_FACEUP) then
			--Its ATK/DEF become 0
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetCode(EFFECT_SET_ATTACK)
			e1:SetValue(0)
			e1:SetReset(RESET_EVENT|RESETS_STANDARD)
			sc:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_SET_DEFENSE)
			sc:RegisterEffect(e2)
		end
		Duel.SpecialSummonComplete()
	end
end
--Hieratic Dragon of Gebeb
if not c78033100 then
	c78033100 = {}
	setmetatable(c78033100,Card)
	rawset(c78033100,"__index",c78033100)
	function c78033100.initial_effect(c)
		--Special Summon 1 Dragon Normal Monster from your hand, Deck, or GY, and make its ATK/DEF 0
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(78033100,0))
		e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
		e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
		e1:SetCode(EVENT_BATTLE_DESTROYING)
		e1:SetCondition(aux.bdogcon)
		e1:SetTarget(c78033100.sptg)
		e1:SetOperation(c78033100.spop(c78033100.normalspfilter))
		e1:SetLabel(1)
		c:RegisterEffect(e1)
		--Special Summon 1 "Hieratic" Normal Monster from your hand, Deck, or GY
		local e2=Effect.CreateEffect(c)
		e2:SetDescription(aux.Stringid(78033100,1))
		e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
		e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
		e2:SetCode(EVENT_RELEASE)
		e2:SetTarget(c78033100.sptg)
		e2:SetOperation(c78033100.spop(c78033100.hieraticspfilter))
		c:RegisterEffect(e2)
	end
	c78033100.listed_series={SET_HIERATIC}
	function c78033100.normalspfilter(c,e,tp,chk)
		return c:IsRace(RACE_DRAGON) and (c:IsType(TYPE_NORMAL) or chk) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	end
	function c78033100.hieraticspfilter(c,e,tp)
		return c:IsSetCard(SET_HIERATIC) and c:IsType(TYPE_NORMAL) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	end
	function c78033100.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return true end
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND|LOCATION_DECK|LOCATION_GRAVE)
	end
	function c78033100.spop(spfilter)
		return  function(e,tp,eg,ep,ev,re,r,rp)
					if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
					local chk=Duel.IsPlayerAffectedByEffect(tp,1331)
					local sc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(spfilter),tp,LOCATION_HAND|LOCATION_DECK|LOCATION_GRAVE,0,1,1,nil,e,tp,chk):GetFirst()
					if sc and Duel.SpecialSummonStep(sc,0,tp,tp,false,false,POS_FACEUP) and e:GetLabel()==1 then
						--Make its ATK/DEF 0
						local e1=Effect.CreateEffect(e:GetHandler())
						e1:SetType(EFFECT_TYPE_SINGLE)
						e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
						e1:SetCode(EFFECT_SET_ATTACK)
						e1:SetValue(0)
						e1:SetReset(RESET_EVENT|RESETS_STANDARD)
						sc:RegisterEffect(e1)
						local e2=e1:Clone()
						e2:SetCode(EFFECT_SET_DEFENSE)
						sc:RegisterEffect(e2)
					end
					Duel.SpecialSummonComplete()
				end
	end
end
--Hieratic Dragon of Nuit
if not c41639001 then
	c41639001 = {}
	setmetatable(c41639001,Card)
	rawset(c41639001,"__index",c41639001)
	function c41639001.initial_effect(c)
		--spsummon
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(41639001,0))
		e1:SetType(EFFECT_TYPE_QUICK_F)
		e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
		e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
		e1:SetCode(EVENT_CHAINING)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCountLimit(1)
		e1:SetCondition(c41639001.spcon)
		e1:SetTarget(c41639001.sptg)
		e1:SetOperation(c41639001.spop)
		c:RegisterEffect(e1)
	end
	function c41639001.spcon(e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler()
		if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
		local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
		return g and g:IsContains(c)
	end
	function c41639001.spfilter(c,e,tp,chk)
		return (c:IsType(TYPE_NORMAL) or chk) and c:IsRace(RACE_DRAGON) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	end
	function c41639001.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return true end
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND|LOCATION_DECK|LOCATION_GRAVE)
	end
	function c41639001.spop(e,tp,eg,ep,ev,re,r,rp)
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local chk=Duel.IsPlayerAffectedByEffect(tp,1331)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c41639001.spfilter),tp,LOCATION_HAND|LOCATION_DECK|LOCATION_GRAVE,0,1,1,nil,e,tp,chk)
		local tc=g:GetFirst()
		if not tc then return end
		if Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SET_ATTACK)
			e1:SetValue(0)
			e1:SetReset(RESET_EVENT|RESETS_STANDARD)
			tc:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_SET_DEFENSE)
			tc:RegisterEffect(e2)
		end
		Duel.SpecialSummonComplete()
	end
end

--Elemental Lord
--Phosphorage the Elemental Lord
if not c8192327 then
	c8192327 = {}
	setmetatable(c8192327,Card)
	rawset(c8192327,"__index",c8192327)
	function c8192327.initial_effect(c)
		c:EnableReviveLimit()
		--cannot special summon
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e1:SetCode(EFFECT_SPSUMMON_CONDITION)
		c:RegisterEffect(e1)
		--special summon
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_SPSUMMON_PROC)
		e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
		e2:SetRange(LOCATION_HAND)
		e2:SetCondition(c8192327.spcon)
		c:RegisterEffect(e2)
		--destroy
		local e3=Effect.CreateEffect(c)
		e3:SetDescription(aux.Stringid(id,0))
		e3:SetCategory(CATEGORY_DESTROY)
		e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
		e3:SetCode(EVENT_SPSUMMON_SUCCESS)
		e3:SetCountLimit(1,id)
		e3:SetTarget(c8192327.destg)
		e3:SetOperation(c8192327.desop)
		c:RegisterEffect(e3)
		--leave
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e4:SetCode(EVENT_LEAVE_FIELD_P)
		e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
		e4:SetOperation(c8192327.leaveop)
		c:RegisterEffect(e4)
	end
	function c8192327.spcon(e,c)
		if c==nil then return true end
		return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and
			Duel.GetMatchingGroupCount(Card.IsAttribute,c:GetControler(),LOCATION_GRAVE,0,nil,ATTRIBUTE_LIGHT)==5
	end
	function c8192327.destg(e,tp,eg,ep,ev,re,r,rp,chk)
		local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
		if chk==0 then return #g>0 end
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,#g,0,0,nil)
	end
	function c8192327.desop(e,tp,eg,ep,ev,re,r,rp)
		local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
		Duel.Destroy(g,REASON_EFFECT)
	end
	function c8192327.cfilter(c,tp,tc)
		local seq=tc:GetSequence()
		if not tc:IsPreviousControler(tp) then seq=seq+16 end
		return bit.extract(c:GetLinkedZone(),seq)~=0 and tc:IsSetCard(SET_ELEMENTAL_LORD)
	end
	function c8192327.leaveop(e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler()
		if c:IsFacedown() then return end
		local fg=Group.CreateGroup()
		local pc
		for i,pe in ipairs({Duel.IsPlayerAffectedByEffect(tp,1213)}) do
			local pc=pe:GetHandler()
			if pc:IsLocation(LOCATION_MZONE) and pc:IsType(TYPE_LINK) then
				fg:AddCard(pc)
			end
		end
		local effp=c:GetControler()
		if fg:IsExists(c8192327.cfilter,1,nil,c,tp) then effp=1-tp end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_SKIP_BP)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(1,0)
		if Duel.GetTurnPlayer()==effp then
			e1:SetLabel(Duel.GetTurnCount())
			e1:SetCondition(c8192327.skipcon)
			e1:SetReset(RESET_PHASE|PHASE_END|RESET_SELF_TURN,2)
		else
			e1:SetReset(RESET_PHASE|PHASE_END|RESET_SELF_TURN,1)
		end
		Duel.RegisterEffect(e1,effp)
	end
	function c8192327.skipcon(e)
		return Duel.GetTurnCount()~=e:GetLabel()
	end
end
--Moulinglacia the Elemental Lord
if not c13959634 then
	c13959634 = {}
	setmetatable(c13959634,Card)
	rawset(c13959634,"__index",c13959634)
	function c13959634.initial_effect(c)
		c:EnableReviveLimit()
		--cannot special summon
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e1:SetCode(EFFECT_SPSUMMON_CONDITION)
		c:RegisterEffect(e1)
		--special summon
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_SPSUMMON_PROC)
		e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
		e2:SetRange(LOCATION_HAND)
		e2:SetCondition(c13959634.spcon)
		c:RegisterEffect(e2)
		--handes
		local e3=Effect.CreateEffect(c)
		e3:SetDescription(aux.Stringid(13959634,0))
		e3:SetCategory(CATEGORY_HANDES)
		e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
		e3:SetCode(EVENT_SPSUMMON_SUCCESS)
		e3:SetCountLimit(1,13959634)
		e3:SetTarget(c13959634.hdtg)
		e3:SetOperation(c13959634.hdop)
		c:RegisterEffect(e3)
		--leave
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e4:SetCode(EVENT_LEAVE_FIELD_P)
		e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
		e4:SetOperation(c13959634.leaveop)
		c:RegisterEffect(e4)
	end
	function c13959634.spcon(e,c)
		if c==nil then return true end
		return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and
			Duel.GetMatchingGroupCount(Card.IsAttribute,c:GetControler(),LOCATION_GRAVE,0,nil,ATTRIBUTE_WATER)==5
	end
	function c13959634.hdtg(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return true end
		Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,1-tp,2)
	end
	function c13959634.hdop(e,tp,eg,ep,ev,re,r,rp)
		local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND):RandomSelect(tp,2)
		Duel.SendtoGrave(g,REASON_EFFECT|REASON_DISCARD)
	end
	function c13959634.cfilter(c,tp,tc)
		local seq=tc:GetSequence()
		if not tc:IsPreviousControler(tp) then seq=seq+16 end
		return bit.extract(c:GetLinkedZone(),seq)~=0 and tc:IsSetCard(SET_ELEMENTAL_LORD)
	end  
	function c13959634.leaveop(e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler()
		if c:IsFacedown() then return end
		local fg=Group.CreateGroup()
		local pc
		for i,pe in ipairs({Duel.IsPlayerAffectedByEffect(tp,1213)}) do
			local pc=pe:GetHandler()
			if pc:IsLocation(LOCATION_MZONE) and pc:IsType(TYPE_LINK) then
				fg:AddCard(pc)
			end
		end
		local effp=c:GetControler()
		if fg:IsExists(c13959634.cfilter,1,nil,c,tp) then effp=1-tp end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_SKIP_BP)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(1,0)
		if Duel.GetTurnPlayer()==effp then
			e1:SetLabel(Duel.GetTurnCount())
			e1:SetCondition(c13959634.skipcon)
			e1:SetReset(RESET_PHASE|PHASE_END|RESET_SELF_TURN,2)
		else
			e1:SetReset(RESET_PHASE|PHASE_END|RESET_SELF_TURN,1)
		end
		Duel.RegisterEffect(e1,effp)
	end
	function c13959634.skipcon(e)
		return Duel.GetTurnCount()~=e:GetLabel()
	end
end
--Pyrorex the Elemental Lord
if not c35842855 then
	c35842855 = {}
	setmetatable(c35842855,Card)
	rawset(c35842855,"__index",c35842855)
	function c35842855.initial_effect(c)
		c:EnableReviveLimit()
		--cannot special summon
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e1:SetCode(EFFECT_SPSUMMON_CONDITION)
		c:RegisterEffect(e1)
		--special summon
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_SPSUMMON_PROC)
		e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
		e2:SetRange(LOCATION_HAND)
		e2:SetCondition(c35842855.spcon)
		c:RegisterEffect(e2)
		--destroy
		local e3=Effect.CreateEffect(c)
		e3:SetDescription(aux.Stringid(35842855,0))
		e3:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
		e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
		e3:SetCode(EVENT_SPSUMMON_SUCCESS)
		e3:SetCountLimit(1,35842855)
		e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
		e3:SetTarget(c35842855.destg)
		e3:SetOperation(c35842855.desop)
		c:RegisterEffect(e3)
		--leave
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e4:SetCode(EVENT_LEAVE_FIELD_P)
		e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
		e4:SetOperation(c35842855.leaveop)
		c:RegisterEffect(e4)
	end
	function c35842855.spcon(e,c)
		if c==nil then return true end
		return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and
			Duel.GetMatchingGroupCount(Card.IsAttribute,c:GetControler(),LOCATION_GRAVE,0,nil,ATTRIBUTE_FIRE)==5
	end
	function c35842855.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
		if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) end
		if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_MZONE,1,nil) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_MZONE,1,1,nil)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
		Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,PLAYER_ALL,0)
	end
	function c35842855.desop(e,tp,eg,ep,ev,re,r,rp)
		local tc=Duel.GetFirstTarget()
		if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)==1 then
			local atk=tc:GetTextAttack()/2
			if atk>0 then
				Duel.Damage(tp,atk,REASON_EFFECT,true)
				Duel.Damage(1-tp,atk,REASON_EFFECT,true)
				Duel.RDComplete()
			end
		end
	end
	function c35842855.cfilter(c,tp,tc)
		local seq=tc:GetSequence()
		if not tc:IsPreviousControler(tp) then seq=seq+16 end
		return bit.extract(c:GetLinkedZone(),seq)~=0 and tc:IsSetCard(SET_ELEMENTAL_LORD)
	end 
	function c35842855.leaveop(e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler()
		if c:IsFacedown() then return end
		local fg=Group.CreateGroup()
		local pc
		for i,pe in ipairs({Duel.IsPlayerAffectedByEffect(tp,1213)}) do
			local pc=pe:GetHandler()
			if pc:IsLocation(LOCATION_MZONE) and pc:IsType(TYPE_LINK) then
				fg:AddCard(pc)
			end
		end
		local effp=c:GetControler()
		if fg:IsExists(c35842855.cfilter,1,nil,c,tp) then effp=1-tp end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_SKIP_BP)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(1,0)
		if Duel.GetTurnPlayer()==effp then
			e1:SetLabel(Duel.GetTurnCount())
			e1:SetCondition(c35842855.skipcon)
			e1:SetReset(RESET_PHASE|PHASE_END|RESET_SELF_TURN,2)
		else
			e1:SetReset(RESET_PHASE|PHASE_END|RESET_SELF_TURN,1)
		end
		Duel.RegisterEffect(e1,effp)
	end
	function c35842855.skipcon(e)
		return Duel.GetTurnCount()~=e:GetLabel()
	end
end
--Windrose the Elemental Lord
if not c53027855 then
	c53027855 = {}
	setmetatable(c53027855,Card)
	rawset(c53027855,"__index",c53027855)
	function c53027855.initial_effect(c)
		c:EnableReviveLimit()
		--cannot special summon
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e1:SetCode(EFFECT_SPSUMMON_CONDITION)
		c:RegisterEffect(e1)
		--special summon
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_SPSUMMON_PROC)
		e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
		e2:SetRange(LOCATION_HAND)
		e2:SetCondition(c53027855.spcon)
		c:RegisterEffect(e2)
		--destroy
		local e3=Effect.CreateEffect(c)
		e3:SetDescription(aux.Stringid(53027855,0))
		e3:SetCategory(CATEGORY_DESTROY)
		e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
		e3:SetCode(EVENT_SPSUMMON_SUCCESS)
		e3:SetCountLimit(1,53027855)
		e3:SetTarget(c53027855.destg)
		e3:SetOperation(c53027855.desop)
		c:RegisterEffect(e3)
		--leave
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e4:SetCode(EVENT_LEAVE_FIELD_P)
		e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
		e4:SetOperation(c53027855.leaveop)
		c:RegisterEffect(e4)
	end
	function c53027855.spcon(e,c)
		if c==nil then return true end
		return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and
			Duel.GetMatchingGroupCount(Card.IsAttribute,c:GetControler(),LOCATION_GRAVE,0,nil,ATTRIBUTE_WIND)==5
	end
	function c53027855.desfilter(c)
		return c:IsSpellTrap()
	end
	function c53027855.destg(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return true end
		local g=Duel.GetMatchingGroup(c53027855.desfilter,tp,0,LOCATION_ONFIELD,nil)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,#g,0,0)
	end
	function c53027855.desop(e,tp,eg,ep,ev,re,r,rp)
		local g=Duel.GetMatchingGroup(c53027855.desfilter,tp,0,LOCATION_ONFIELD,nil)
		Duel.Destroy(g,REASON_EFFECT)
	end
	function c53027855.cfilter(c,tp,tc)
		local seq=tc:GetSequence()
		if not tc:IsPreviousControler(tp) then seq=seq+16 end
		return bit.extract(c:GetLinkedZone(),seq)~=0 and tc:IsSetCard(SET_ELEMENTAL_LORD)
	end  
	function c53027855.leaveop(e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler()
		if c:IsFacedown() then return end
		local fg=Group.CreateGroup()
		local pc
		for i,pe in ipairs({Duel.IsPlayerAffectedByEffect(tp,1213)}) do
			local pc=pe:GetHandler()
			if pc:IsLocation(LOCATION_MZONE) and pc:IsType(TYPE_LINK) then
				fg:AddCard(pc)
			end
		end
		local effp=c:GetControler()
		if fg:IsExists(c53027855.cfilter,1,nil,c,tp) then effp=1-tp end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_SKIP_BP)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(1,0)
		if Duel.GetTurnPlayer()==effp then
			e1:SetLabel(Duel.GetTurnCount())
			e1:SetCondition(c53027855.skipcon)
			e1:SetReset(RESET_PHASE|PHASE_END|RESET_SELF_TURN,2)
		else
			e1:SetReset(RESET_PHASE|PHASE_END|RESET_SELF_TURN,1)
		end
		Duel.RegisterEffect(e1,effp)
	end
	function c53027855.skipcon(e)
		return Duel.GetTurnCount()~=e:GetLabel()
	end
end
--Umbramirage the Elemental Lord
if not c59281822 then
	c59281822 = {}
	setmetatable(c59281822,Card)
	rawset(c59281822,"__index",c59281822)
	function c59281822.initial_effect(c)
		c:EnableReviveLimit()
		--cannot special summon
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e1:SetCode(EFFECT_SPSUMMON_CONDITION)
		c:RegisterEffect(e1)
		--special summon
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_SPSUMMON_PROC)
		e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
		e2:SetRange(LOCATION_HAND)
		e2:SetCondition(c59281822.spcon)
		c:RegisterEffect(e2)
		--to hand
		local e3=Effect.CreateEffect(c)
		e3:SetDescription(aux.Stringid(59281822,0))
		e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
		e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
		e3:SetCode(EVENT_SPSUMMON_SUCCESS)
		e3:SetCountLimit(1,59281822)
		e3:SetTarget(c59281822.thtg)
		e3:SetOperation(c59281822.thop)
		c:RegisterEffect(e3)
		--leave
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e4:SetCode(EVENT_LEAVE_FIELD_P)
		e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
		e4:SetOperation(c59281822.leaveop)
		c:RegisterEffect(e4)
	end
	function c59281822.spcon(e,c)
		if c==nil then return true end
		return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and
			Duel.GetMatchingGroupCount(Card.IsAttribute,c:GetControler(),LOCATION_GRAVE,0,nil,ATTRIBUTE_DARK)==5
	end
	function c59281822.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return true end
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	end
	function c59281822.filter(c)
		return c:IsAttackBelow(1500) and c:IsMonster() and c:IsAbleToHand()
	end
	function c59281822.thop(e,tp,eg,ep,ev,re,r,rp)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c59281822.filter,tp,LOCATION_DECK,0,1,1,nil)
		if #g>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
	function c59281822.cfilter(c,tp,tc)
		local seq=tc:GetSequence()
		if not tc:IsPreviousControler(tp) then seq=seq+16 end
		return bit.extract(c:GetLinkedZone(),seq)~=0 and tc:IsSetCard(SET_ELEMENTAL_LORD)
	end	 
	function c59281822.leaveop(e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler()
		if c:IsFacedown() then return end
		local fg=Group.CreateGroup()
		local pc
		for i,pe in ipairs({Duel.IsPlayerAffectedByEffect(tp,1213)}) do
			local pc=pe:GetHandler()
			if pc:IsLocation(LOCATION_MZONE) and pc:IsType(TYPE_LINK) then
				fg:AddCard(pc)
			end
		end
		local effp=c:GetControler()
		if fg:IsExists(c59281822.cfilter,1,nil,c,tp) then effp=1-tp end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_SKIP_BP)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(1,0)
		if Duel.GetTurnPlayer()==effp then
			e1:SetLabel(Duel.GetTurnCount())
			e1:SetCondition(c59281822.skipcon)
			e1:SetReset(RESET_PHASE|PHASE_END|RESET_SELF_TURN,2)
		else
			e1:SetReset(RESET_PHASE|PHASE_END|RESET_SELF_TURN,1)
		end
		Duel.RegisterEffect(e1,effp)
	end
	function c59281822.skipcon(e)
		return Duel.GetTurnCount()~=e:GetLabel()
	end
end
--Grandsoil the Elemental Lord
if not c61468779 then
	c61468779 = {}
	setmetatable(c61468779,Card)
	rawset(c61468779,"__index",c61468779)
	function c61468779.initial_effect(c)
		c:EnableReviveLimit()
		--cannot special summon
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e1:SetCode(EFFECT_SPSUMMON_CONDITION)
		c:RegisterEffect(e1)
		--special summon
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_SPSUMMON_PROC)
		e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
		e2:SetRange(LOCATION_HAND)
		e2:SetCondition(c61468779.spcon)
		c:RegisterEffect(e2)
		--spsummon
		local e3=Effect.CreateEffect(c)
		e3:SetDescription(aux.Stringid(61468779,0))
		e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
		e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
		e3:SetCode(EVENT_SPSUMMON_SUCCESS)
		e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
		e3:SetCountLimit(1,61468779)
		e3:SetTarget(c61468779.sptg)
		e3:SetOperation(c61468779.spop)
		c:RegisterEffect(e3)
		--leave
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e4:SetCode(EVENT_LEAVE_FIELD_P)
		e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
		e4:SetOperation(c61468779.leaveop)
		c:RegisterEffect(e4)
	end
	function c61468779.spcon(e,c)
		if c==nil then return true end
		return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and
			Duel.GetMatchingGroupCount(Card.IsAttribute,c:GetControler(),LOCATION_GRAVE,0,nil,ATTRIBUTE_EARTH)==5
	end
	function c61468779.filter(c,e,tp)
		return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	end
	function c61468779.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
		if chkc then return chkc:IsLocation(LOCATION_GRAVE) and c61468779.filter(chkc,e,tp) end
		if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and Duel.IsExistingTarget(c61468779.filter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,e,tp) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectTarget(tp,c61468779.filter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil,e,tp)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
	end
	function c61468779.spop(e,tp,eg,ep,ev,re,r,rp)
		local tc=Duel.GetFirstTarget()
		if tc:IsRelateToEffect(e) then
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		end
	end
	function c61468779.cfilter(c,tp,tc)
		local seq=tc:GetSequence()
		if not tc:IsPreviousControler(tp) then seq=seq+16 end
		return bit.extract(c:GetLinkedZone(),seq)~=0 and tc:IsSetCard(SET_ELEMENTAL_LORD)
	end	 
	function c61468779.leaveop(e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler()
		if c:IsFacedown() then return end
		local fg=Group.CreateGroup()
		local pc
		for i,pe in ipairs({Duel.IsPlayerAffectedByEffect(tp,1213)}) do
			local pc=pe:GetHandler()
			if pc:IsLocation(LOCATION_MZONE) and pc:IsType(TYPE_LINK) then
				fg:AddCard(pc)
			end
		end
		local effp=c:GetControler()
		if fg:IsExists(c61468779.cfilter,1,nil,c,tp) then effp=1-tp end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_SKIP_BP)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(1,0)
		if Duel.GetTurnPlayer()==effp then
			e1:SetLabel(Duel.GetTurnCount())
			e1:SetCondition(c61468779.skipcon)
			e1:SetReset(RESET_PHASE|PHASE_END|RESET_SELF_TURN,2)
		else
			e1:SetReset(RESET_PHASE|PHASE_END|RESET_SELF_TURN,1)
		end
		Duel.RegisterEffect(e1,effp)
	end
	function c61468779.skipcon(e)
		return Duel.GetTurnCount()~=e:GetLabel()
	end
end
--Grandsoil the Elemental Lord(Pre-Errata)
if not c511003062 then
	c511003062 = {}
	setmetatable(c511003062,Card)
	rawset(c511003062,"__index",c511003062)
	function c511003062.initial_effect(c)
		c:EnableReviveLimit()
		--cannot special summon
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e1:SetCode(EFFECT_SPSUMMON_CONDITION)
		c:RegisterEffect(e1)
		--special summon
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_SPSUMMON_PROC)
		e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
		e2:SetRange(LOCATION_HAND)
		e2:SetCondition(c511003062.spcon)
		c:RegisterEffect(e2)
		--spsummon
		local e3=Effect.CreateEffect(c)
		e3:SetDescription(aux.Stringid(61468779,0))
		e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
		e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
		e3:SetCode(EVENT_SPSUMMON_SUCCESS)
		e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
		e3:SetTarget(c511003062.sptg)
		e3:SetOperation(c511003062.spop)
		c:RegisterEffect(e3)
		--leave
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e4:SetCode(EVENT_LEAVE_FIELD_P)
		e4:SetOperation(c511003062.leaveop)
		c:RegisterEffect(e4)
	end
	function c511003062.spcon(e,c)
		if c==nil then return true end
		return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and
			Duel.GetMatchingGroupCount(Card.IsAttribute,c:GetControler(),LOCATION_GRAVE,0,nil,ATTRIBUTE_EARTH)==5
	end
	function c511003062.filter(c,e,tp)
		return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	end
	function c511003062.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
		if chkc then return chkc:IsLocation(LOCATION_GRAVE) and c511003062.filter(chkc,e,tp) end
		if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and Duel.IsExistingTarget(c511003062.filter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,e,tp) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectTarget(tp,c511003062.filter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil,e,tp)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
	end
	function c511003062.spop(e,tp,eg,ep,ev,re,r,rp)
		local tc=Duel.GetFirstTarget()
		if tc and tc:IsRelateToEffect(e) then
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		end
	end
	function c511003062.cfilter(c,tp,tc)
		local seq=tc:GetSequence()
		if not tc:IsPreviousControler(tp) then seq=seq+16 end
		return bit.extract(c:GetLinkedZone(),seq)~=0 and tc:IsSetCard(SET_ELEMENTAL_LORD)
	end	 
	function c511003062.leaveop(e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler()
		if c:IsFacedown() then return end
		local fg=Group.CreateGroup()
		local pc
		for i,pe in ipairs({Duel.IsPlayerAffectedByEffect(tp,1213)}) do
			local pc=pe:GetHandler()
			if pc:IsLocation(LOCATION_MZONE) and pc:IsType(TYPE_LINK) then
				fg:AddCard(pc)
			end
		end
		local effp=c:GetControler()
		if fg:IsExists(c511003062.cfilter,1,nil,c,tp) then effp=1-tp end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_SKIP_BP)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(1,0)
		if Duel.GetTurnPlayer()==effp then
			e1:SetLabel(Duel.GetTurnCount())
			e1:SetCondition(c511003062.skipcon)
			e1:SetReset(RESET_PHASE|PHASE_END|RESET_SELF_TURN,2)
		else
			e1:SetReset(RESET_PHASE|PHASE_END|RESET_SELF_TURN,1)
		end
		Duel.RegisterEffect(e1,effp)
	end
	function c511003062.skipcon(e)
		return Duel.GetTurnCount()~=e:GetLabel()
	end
end